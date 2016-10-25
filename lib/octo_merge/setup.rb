module OctoMerge
  class Setup
    def initialize(options)
      @options = options
    end

    def self.run(*args)
      new(*args).tap { |setup| setup.run }
    end

    def run
      setup_user_config_file
      setup_project_config_file
    end

    private

    HINTS = {
      login: "login is your GitHub username",
      password: "You can manage your GitHub API tokens at: https://github.com/settings/tokens"
    }
    private_constant :HINTS

    attr_reader :options

    def setup_user_config_file
      setup(
        name: "user",
        path: Options.user_config_path,
        attributes: [:login, :password],
        default: true
      )
    end

    def setup_project_config_file
      setup(
        name: "project",
        path: Options.pathname,
        attributes: [:repo, :strategy, :query],
        default: false
      )
    end

    def setup(name:, path:, attributes:, default:)
      return unless Ask.confirm "Create #{name} config file? (#{path})", default: default

      create(path: path, config: config_for(attributes))
    end

    def config_for(attributes)
      attributes.inject({}) { |hash, key|
        hash[key] = ask_for(key)
        hash
      }
    end

    def ask_for(key)
      puts "[INFO] #{HINTS[key]}" if HINTS[key]

      Ask.input "#{key}", default: options.send(key)
    end

    def create(path:, config:)
      File.write(path.to_s, content_for(config))
    end

    def content_for(config)
      config
        .select { |key, value| !value.nil? && value != "" }
        .map { |key, value| "#{key}: \"#{value}\"" }
        .join("\n")
    end
  end
end
