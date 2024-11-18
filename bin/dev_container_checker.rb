#!/usr/bin/env ruby
require 'json'
require 'open3'
require 'fileutils'
require 'time'
require 'optparse'

class DevContainerChecker
  GITHUB_ORG = 'rails'
  OUTPUT_FILE = 'devcontainer_build_results.json'
  RED = "\e[31m"
  GREEN = "\e[32m"
  RESET = "\e[0m"

  def initialize(org:, summary_only: false)
    @org = org.nil? ? GITHUB_ORG : org
    @launch_dir = Dir.pwd
    @results_file = File.join(@launch_dir, OUTPUT_FILE)
    @results = load_existing_results
    @processed_count = 0
    @summary_only = summary_only
  end

  def run
    if @summary_only
      print_summary
    else
      update_repositories
      check_devcontainers
      print_summary
    end
  end

  private

  def load_existing_results
    return {} unless File.exist?(@results_file)
    JSON.parse(File.read(@results_file))
  rescue JSON::ParserError
    {}
  end

  def save_results
    FileUtils.mkdir_p(File.dirname(@results_file))
    
    # Load existing results (if any) and merge with new results
    existing_results = load_existing_results
    merged_results = existing_results.merge(@results)
    
    # Write back to the launch directory
    File.write(@results_file, JSON.pretty_generate(merged_results))
  end

  def update_repositories
    puts "Fetching repositories for '#{@org}'..."
    repos_json, status = Open3.capture2("gh repo list rails --json name,url")
    repos = JSON.parse(repos_json)
    
    repos.each do |repo|
      clone_url = repo['url']
      repo_name = repo['name']
      
      if Dir.exist?(repo_name)
        puts "Updating #{repo_name}..."
        Dir.chdir(repo_name) do
          system("git pull")
        end
      else
        puts "Cloning #{repo_name}..."
        system("git clone #{clone_url}")
      end
    end
  end

  def check_devcontainers
    Dir.glob('*').select { |f| File.directory?(f) }.each do |dir|
      next unless File.directory?("#{dir}/.devcontainer")
      
      @processed_count += 1
      puts "Found .devcontainer in #{dir}, building..."
      process_devcontainer(dir)
    end
  end

  def colorize_error(text)
    return text unless text.include?('ERROR') || text.start_with?('Error:')
    "#{RED}#{text}#{RESET}"
  end

  def process_devcontainer(dir)
    Dir.chdir(dir) do
      command = "devcontainer build --workspace-folder ."
      
      # Create a new thread to handle real-time output
      output_thread = nil
      stderr_thread = nil
      
      begin
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          # Thread for standard output
          output_thread = Thread.new do
            while line = stdout.gets
              puts line
              (@stdout ||= []) << line
            end
          end
          
          # Thread for standard error
          stderr_thread = Thread.new do
            while line = stderr.gets
              puts colorize_error(line)
              (@stderr ||= []) << line
            end
          end
          
          # Wait for process to complete
          output_thread.join
          stderr_thread.join
          
          @results[dir] = {
            'success' => wait_thr.value.success?,
            'exit_code' => wait_thr.value.exitstatus,
            'stdout' => @stdout.join,
            'stderr' => @stderr.join,
            'error_messages' => extract_error_messages((@stdout + @stderr).join("\n")),
            'timestamp' => Time.now.iso8601
          }
          
          # Save results after each build
          save_results
        end
      rescue => e
        error_message = colorize_error(e.message)
        puts error_message
        @results[dir] = {
          'success' => false,
          'error' => e.message,
          'error_messages' => [e.message],
          'timestamp' => Time.now.iso8601
        }
        save_results
      end
      
      # Clear output buffers for next run
      @stdout = []
      @stderr = []
    end
  end

  def extract_error_messages(output)
    output.split("\n").select { |line| line.include?('ERROR') }
  end

  def print_summary
    unless File.exist?(@results_file)
      puts "#{RED}No results file found at #{@results_file}#{RESET}"
      exit 1
    end

    successful = @results.count { |_, v| v['success'] }
    failed = @results.count { |_, v| !v['success'] }
    total = @results.count

    latest_run = @results.max_by { |_, v| Time.parse(v['timestamp']) rescue Time.at(0) }
    latest_time = latest_run ? Time.parse(latest_run[1]['timestamp']).strftime('%Y-%m-%d %H:%M:%S') : 'Unknown'

    puts "\n" + "="*50
    puts "EXECUTION SUMMARY"
    puts "="*50
    puts "Results file: #{@results_file}"
    puts "Last run: #{latest_time}"
    puts "Total projects processed: #{total}"
    puts "#{GREEN}Successful builds: #{successful}#{RESET}"
    puts "#{RED}Failed builds: #{failed}#{RESET}"

    if failed > 0
      puts "\n#{RED}Failed projects:#{RESET}"
      @results.each do |project, data|
        unless data['success']
          puts "- #{project}"
        end
      end
    end
    puts "="*50
  end
end

# Parse command line options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"
  opts.on("--summary", "Print summary of last run only") do |v|
    options[:summary] = v
  end
  opts.on("--org ORG", "Specify the GitHub org to query. Default: 'rails'.") do |org|
    options[:org] = org.empty? ? DevContainerChecker::GITHUB_ORG : org
  end
end.parse!

# Check if GitHub CLI is installed (skip if only showing summary)
unless options[:summary]
  unless system('which gh > /dev/null 2>&1')
    puts "#{RED}Error: GitHub CLI (gh) is not installed. Please install it first.#{RESET}"
    exit 1
  end

  # Check if gh is authenticated
  unless system('gh auth status > /dev/null 2>&1')
    puts "#{RED}Error: GitHub CLI is not authenticated. Please run 'gh auth login' first.#{RESET}"
    exit 1
  end
end

# Run the checker
checker = DevContainerChecker.new(org: options[:org], summary_only: options[:summary])
checker.run
