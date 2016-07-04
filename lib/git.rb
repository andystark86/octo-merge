require 'open3'

# TODO: Move to another repository (e.g.: `SimpleGit`)
class Git
  def self.git(method_name, cmd = nil)
    define_method(method_name) do |args|
      if cmd
        git("#{cmd} #{args}")
      else
        git("#{method_name} #{args}")
      end
    end
  end

  def self.verbose!(is_verbose = true)
    @verbose = is_verbose
  end

  def self.verbose?
    !!@verbose
  end

  attr_reader :working_directory

  def initialize(working_directory)
    @working_directory ||= File.absolute_path(working_directory)
  end

  git :checkout
  git :commit
  git :fetch
  git :merge_no_ff, "merge --no-ff"
  git :rebase
  git :remote_add, "remote add"
  git :reset_hard, "reset --hard"

  private

  def git(cmd)
    run "git #{cmd}"
  end

  def verbose?
    self.class.verbose?
  end

  def run(cmd)
    cmd = <<-CMD
      cd #{working_directory} &&
      #{cmd}
    CMD

    # NOTE: Logging and debugging is writte to stderr
    _stdin, stdout, stderr = Open3.popen3(cmd)
    print stderr.read if verbose?
    stdout.read
  end
end
