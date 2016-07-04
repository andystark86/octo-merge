module OctoMerge
  module Strategy
    class Rebase < Base
      def run
        fetch_master

        pull_requests.each do |pull_request|
          fetch(pull_request)

          git.checkout(pull_request.number_branch)
          git.rebase(master)

          git.checkout(master)
          git.rebase("#{pull_request.number_branch}")

          git.delete_branch(pull_request.number_branch)
        end
      end
    end
  end
end
