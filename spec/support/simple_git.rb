require 'fileutils'
require 'open3'

class SimpleGit
  REPOS_PATH = "tmp/repos"

  attr_reader :name

  def initialize(name:)
    @name = name
  end

  class << self
    def create(*args)
      new(*args).tap { |git| git.create }
    end

    def clear!
      FileUtils.rm_rf(REPOS_PATH) if Dir.exist?(REPOS_PATH)
      FileUtils.mkdir_p(REPOS_PATH)
    end
  end

  def create
    FileUtils.mkdir_p(path)
    git "init ."
  end

  def add_remote(remote)
    remote_path = File.absolute_path(File.join(path, "../#{remote}/.git"))

    git "remote add #{remote} #{remote_path}"
  end

  def add_item(item)
    run "touch #{item}"
    git "add #{item}"
    git "commit -m 'Adds #{item}'"
  end

  def reset(remote, branch)
    fetch(remote)
    git "reset --hard #{remote}/#{branch}"
  end

  def checkout(branch)
    git "checkout #{branch}"
  end

  def checkout_branch(branch)
    git "checkout -b #{branch}"
  end

  def merge_no_ff(remote, branch = nil)
    if branch.nil?
      git "merge --no-ff #{remote}"
    else
      git "merge --no-ff #{remote}/#{branch}"
    end
  end

  def fetch(remote)
    git "fetch #{remote}"
  end

  def rebase(branch)
    git "rebase #{branch}"
  end

  def history
    git("log --graph --pretty=format:'%s'").split("\n").map(&:strip).join("\n")
  end

  def show(args = nil)
    git "show #{args}"
  end

  # private

  def git(cmd)
    run "git #{cmd}"
  end

  def run(cmd)
    cmd = <<-CMD
      cd #{path} &&
      #{cmd}
    CMD

    # NOTE: Logging and debugging is writte to stderr
    _stdin, stdout, _stderr = Open3.popen3(cmd)
    stdout.read
  end

  def path
    @path ||= File.absolute_path("#{REPOS_PATH}/#{name}")
  end
end
