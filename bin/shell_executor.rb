require 'open3'
require 'English'

module ShellExecutor
  # return IO
  def shell_exec(cmd)
    Open3.popen3(cmd) do |_stdin, stdout, stderr, wait_thr|
      begin
        while Process.waitpid(wait_thr.pid, Process::WNOHANG).nil?
          stdout.each_line { |line| puts line.strip }
          stderr.each_line { |line| puts line.strip }
          sleep(0.5)
        end
      rescue Errno::ECHILD # in case process exits very quickly
      end
      stdout.each_line { |line| puts line.strip }
      stderr.each_line { |line| puts line.strip }
    end
  end
end
