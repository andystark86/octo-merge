# == Links
#
# * https://www.atlassian.com/git/tutorials/merging-vs-rebasing/workflow-walkthrough
# * https://www.atlassian.com/git/articles/git-team-workflows-merge-or-rebase/
module OctoMerge
  module Strategy
    class Base
      attr_reader :working_directory, :pull_requests

      def initialize(working_directory:, pull_requests:)
        @working_directory = working_directory
        @pull_requests = pull_requests
      end

      def self.run(*args)
        new(*args).tap { |strategy| strategy.run }
      end

      def run
        fail NotImplementedError
      end

      private

      def git
        @git ||= Git.new(working_directory)
      end

      # Fetch the read-only branch for the corresponding pull request and
      # create a local branch to rebase the current master on.
      #
      # Read more: [Checking out pull requests locally](https://help.github.com/articles/checking-out-pull-requests-locally/)
      def fetch(pull_request)
        git.fetch "#{upstream} #{pull_request.number_branch}/head:#{pull_request.number_branch} --force"
      end

      def fetch_master
        git.checkout(master)
        git.fetch(upstream)
        git.reset_hard("#{upstream}/#{master}")
      end


      def upstream
        :upstream
      end

      def master
        :master
      end
    end
  end
end
