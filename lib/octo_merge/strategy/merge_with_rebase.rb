module OctoMerge
  module Strategy
    class MergeWithRebase < Base
      def run
        fetch_master

        pull_requests.each do |pull_request|
          fetch(pull_request)

          git.checkout(pull_request.number_branch)
          git.rebase(master)

          git.checkout(master)
          merge(pull_request)

          git.delete_branch(pull_request.number_branch)
        end
      end

      private

      def merge(pull_request)
        message = "Merge branch '#{pull_request.remote_branch}'"

        git.merge_no_ff("-m \"#{message}\" #{pull_request.number_branch}")
      end
    end
  end
end
