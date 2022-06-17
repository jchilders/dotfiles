# frozen_string_literal: true

require_relative 'status_line'

# Collection of `Statusline`s
class StatusLines
  include Enumerable

  def initialize
    statuses = `git status --porcelain=v2`.split("\n")
    @status_lines = [].tap do |ary|
      statuses.each do |line_str|
        ary << StatusLine.new(line_str)
      end
    end
  end

  def each(&block)
    @status_lines.each(&block)
  end
end
