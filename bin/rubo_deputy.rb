#!/usr/bin/env ruby

require 'English'
require 'pry'
require 'set'
require 'forwardable'

# Let's you do RuboCop things one directory at a time
module RuboDeputy
  module DirWalker
    def subdirs
      @subdirs ||= Dir["#{dir_to_clean}/**/*"].filter { |dir| File.directory?(dir) }
    end
  end

  class Deputy
    extend Forwardable
    include RuboDeputy::DirWalker

    PROGRESS_FILE = 'rubocop_progress'.freeze
    attr_accessor :dir_to_clean, :progress

    class << self
      def unmarshal_progress
        Marshal.load(File.read(PROGRESS_FILE))
      end
    end
    delegate unmarshal_progress: self

    def initialize(dir_to_clean)
      @dir_to_clean = dir_to_clean
      @progress = if File.exist?(PROGRESS_FILE)
                    unmarshal_progress
                  else
                    empty_progress
                  end
    end

    def clean!
      clean_subdirs!
      clean_root!
      marshal_progress
      add_to_git
    end

    def clean_subdirs!
      subdirs.each do |dir|
        lint_and_test!(dir)
      end
    end

    def clean_root!
      root_files = Dir["#{dir_to_clean}/*"].filter { |f| File.file?(f) }
      return unless root_files.size.positive?

      file_list = root_files.join(' ')
      run_rubocop(file_list)

      unless $CHILD_STATUS.success?
        puts 'error running rubocop'
        add_error(dir_to_clean)
        `git checkout #{file_list}`
        return
      end
      add_done(dir_to_clean)
    end

    def reset!
      File.delete(PROGRESS_FILE) if File.exist?(PROGRESS_FILE)
      @progress = empty_progress
    end

    def lint_and_test!(dir)
      print "#{dir}: "
      if skippable_dirs.member?(dir)
        puts 'skipping'
        return
      end

      run_rubocop(dir)
      # `rubocop --autocorrect --fail-level E #{dir}`
      unless $CHILD_STATUS.success?
        puts 'error running rubocop'
        add_error(dir)
        `git checkout #{dir}`

        return
      end

      # If nothing changed go to next dir
      `git diff --quiet -- #{dir}`
      if $CHILD_STATUS.success?
        puts 'nothing to clean'
        add_done(dir)
        return
      end

      test_dir = dir.gsub(/^app/, 'test')
      print 'testing '
      if Dir.exist?(test_dir)
        print "#{test_dir}..."
        `rails test #{test_dir}`
      else
        print 'all...'
        `rails test`
      end

      unless $CHILD_STATUS.success?
        puts 'test(s) failed'
        add_failure(dir)

        return
      end

      add_done(dir)
      puts ' done!'
    end

    def marshal_progress
      print_stats
      File.write(PROGRESS_FILE, Marshal.dump(progress))
    end

    def print_stats
      puts "Num dirs with Rubocop errors: #{progress[:err_dirs].size}"
      puts "Num dirs with test failures: #{progress[:failed_dirs].size}"
      puts "Num completed dirs: #{progress[:done_dirs].size}"
    end

    private

    def add_error(dir)
      add_dir_progress(:err_dirs, dir)
    end

    def add_failure(dir)
      add_dir_progress(:failed_dirs, dir)
    end

    def add_done(dir)
      add_dir_progress(:done_dirs, dir)
    end

    def add_dir_progress(key, dir)
      return unless Dir.exist?(dir)

      progress[key] << dir
    end

    def empty_progress
      {
        err_dirs: Set.new,
        failed_dirs: Set.new,
        done_dirs: Set.new,
      }
    end

    def skippable_dirs
      progress[:err_dirs] + progress[:failed_dirs] + progress[:done_dirs]
    end

    def run_rubocop(dir_or_files)
      `rubocop --autocorrect --fail-level E #{dir_or_files}`
    end

    def add_to_git
      progress[:done_dirs].each do |dir|
        `git add #{dir}`
      end
    end
  end
end


# class TestRunner
#   attr_reader :dir

#   include DirWalker

#   def initialize(dir)
#     @dir = dir
#   end

# end

if ARGV[0].nil?
  warn "Usage: #{File.basename(__FILE__)} <path>"
  exit 1
end

@deputy = RuboDeputy::Linter.new(ARGV[0])
Signal.trap('INT') do
  puts 'Saving progress'
  @deputy.marshal_progress
  exit 1
end

@deputy.clean!
