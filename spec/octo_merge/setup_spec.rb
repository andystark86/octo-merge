require "spec_helper"

describe OctoMerge::Setup do
  subject(:setup) { described_class.new(options) }

  let(:options) {
    instance_double(OctoMerge::Options,
      login: "me",
      password: "42",
      repo: "rails",
      strategy: "simple",
      query: "label:ready-to-merge",
      setup: true
    )
  }

  let(:user_config_path) { OctoMerge::Options.user_config_path }
  let(:project_config_path) { OctoMerge::Options.pathname.realpath.to_s }

  describe "#run" do
    subject { setup.run }

    let(:create_user_config_file) { false }
    let(:create_project_config_file) { false }

    before do
      expect(Ask).to receive(:confirm)
        .with("Create user config file? (#{user_config_path})", default: true)
        .and_return(create_user_config_file)

      expect(Ask).to receive(:confirm)
        .with("Create project config file? (#{project_config_path})", default: false)
        .and_return(create_project_config_file)
    end

    before do
      allow(Ask).to receive(:input).with("login", default: "me").and_return("you")
      allow(Ask).to receive(:input).with("password", default: "42").and_return("23")

      allow(Ask).to receive(:input).with("repo", default: "rails").and_return("rails")
      allow(Ask).to receive(:input).with("strategy", default: "simple").and_return("simple")
      allow(Ask).to receive(:input).with("query", default: "label:ready-to-merge").and_return("")
    end

    context "when answered yes to 'Create user config file?'" do
      let(:create_user_config_file) { true }

      let(:expected_content) {
        <<-EXPECTED_CONTENT.strip
login: "you"
password: "23"
EXPECTED_CONTENT
      }

      it "writes the input to user config" do
        expect(File).to receive(:write)
          .with(user_config_path, expected_content)
          .and_return(true)
        subject
      end
    end

    context "when answered yes to 'Create project config file?'" do
      let(:create_project_config_file) { true }

      let(:expected_content) {
        <<-EXPECTED_CONTENT.strip
repo: "rails"
strategy: "simple"
EXPECTED_CONTENT
      }

      it "writes the input to project config" do
        expect(File).to receive(:write)
          .with(project_config_path, expected_content)
          .and_return(true)
        subject
      end
    end
  end
end
