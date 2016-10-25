require 'inquirer'

module OctoMerge
  class InteractivePullRequests
    def initialize(repo:, query:)
      @repo = repo
      @query = query
    end

    def self.get(options = {})
      new(repo: options[:repo], query: options[:query]).to_s
    end

    def to_s
      system("clear")

      idx = Ask.checkbox(
        "Select the pull requests you want to merge",
        formatted_pull_requests
      )

      idx.zip(pull_requests).select { |e| e[0] }.map { |e| e[1].number }.join(",")
    end

    private

    attr_reader :repo, :query

    def formatted_pull_requests
      pull_requests.map do |pull_request|
        format_pull_request(pull_request)
      end
    end

    def pull_requests
      list.all
    end

    def format_pull_request(pull_request)
      "#{pull_request.number}: \"#{pull_request.title}\" by @#{pull_request.user.login}"
    end

    def list
      @list ||= OctoMerge::ListPullRequests.new(repo: repo, query: query)
    end
  end
end
