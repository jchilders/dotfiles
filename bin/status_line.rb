# frozen_string_literal: true

# Represents a line from `git status --porcelain=v2`.

# A v2 porcelain line looks like one of the following:
# Simple changed entries:
#   1 <XY> <sub> <mH> <mI> <mW> <hH> <hI> <path>
# Renamed entries:
#   2 <XY> <sub> <mH> <mI> <mW> <hH> <hI> <X><score> <path><sep><origPath>
# Unmerged:
#   u <XY> <sub> <m1> <m2> <m3> <mW> <h1> <h2> <h3> <path>
# New:
#   ? <path>
class StatusLine
  include Comparable

  # the git docs refer the "short-format status" field as `xy`. It indicates the status of the file in the index and the working tree.
  attr_reader :type, :xy

  def initialize(str)
    @line = str.split
    @type = @line[0]
    @xy = @type != '?' ? @line[1] : '??'
  end

  def changed?
    type == '1'
  end

  def staged?
    changed? && !!(xy =~ /[ADMR]\./)
  end

  def renamed?
    !!(xy =~ /R\./)
  end

  def deleted?
    !!(xy =~ /D\./)
  end

  def old_path
    renamed? ? @line[-2] : ''
  end

  def test_file?
    path =~ /^(test|spec).*_test\.rb$/
  end

  def path
    if renamed?
      "#{@line[-1]} -> #{@line[-2]}"
    else
      @line[-1]
    end
  end

  # @return [Time]
  def mtime
    File.new(path).mtime
  rescue
    Time.new(0) # just make it old
  end

  def <=>(other)
    return 1 if staged? && !other.staged?
    return -1 if !staged? && other.staged?
    return 1 if renamed?

    other.mtime <=> mtime
  end

  def to_s
    xy_str = xy.gsub('.', ' ')
    "#{xy_str} #{path}"
  end
end
