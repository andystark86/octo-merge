module OctoMerge
  class Execute
    attr_reader :context, :strategy, :remote

    # TODO: move `remote` into context
    def initialize(context:, strategy:, remote:)
      @context = context
      @strategy = strategy
      @remote = remote
    end

    def run
      env.run
    end

    def env
      @env ||= strategy.new(
        working_directory: context.working_directory,
        pull_requests: context.pull_requests,
        remote: remote
      )
    end
  end
end
