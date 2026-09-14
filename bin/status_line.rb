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

  # Used to stop splitting a line once <path> is reached for a given v2 porcelain line, so that a path containing
  # spaces stays intact.
  PATH_INDEX = { '1' => 8, '2' => 9, 'u' => 10 }.freeze

  def initialize(str)
    index = PATH_INDEX.fetch(str[0, 1], 1)
    @line = str.split(' ', index + 1)
    @type = @line[0]
    @xy = @type != '?' ? @line[1] : '??'
    # A rename packs both names into the path field, separated by a tab.
    @path, @old_path = @line[index].to_s.split("\t", 2)
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
    @old_path.to_s
  end

  def test_file?
    path =~ /^(test|spec).*_test\.rb$/
  end

  def path
    renamed? ? "#{old_path} -> #{@path}" : @path
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
