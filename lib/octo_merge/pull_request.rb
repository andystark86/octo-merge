require "octokit"

module OctoMerge
  class PullRequest
    attr_reader :repo, :number

    def initialize(repo:, number:)
      @repo = repo
      @number = number.to_s
    end

    def url
      github_api_result.html_url
    end

    def remote
      github_api_result.user.login
    end

    def remote_url
      github_api_result.head.repo.ssh_url
    end

    def remote_branch
      github_api_result.head.ref
    end

    def number_branch
      "pull/#{number}"
    end

    def title
      github_api_result.title
    end

    def body
      github_api_result.body
    end

    def ==(other_pull_request)
      repo == other_pull_request.repo && number == other_pull_request.number
    end

    private

    def github_api_result
      @github_api_result ||= github_client.pull_request(repo, number)
    end

    def github_client
      OctoMerge.github_client
    end
  end
end
