require 'spec_helper'

describe OctoMerge::PullRequest do
  include WebmockStubs

  subject(:pull_request) {
    described_class.new(repo: "rails/rails", number: "23")
  }

  its(:url) { is_expected.to eq("https://github.com/rails/rails/pull/23") }
  its(:remote) { is_expected.to eq("jackdempsey") }
  its(:remote_url) { is_expected.to eq("git@github.com:jackdempsey/rails.git") }
  its(:remote_branch) { is_expected.to eq("fix_requires") }
  its(:number_branch) { is_expected.to eq("pull/23") }
  its(:number) { is_expected.to eq("23") }
  its(:title) { is_expected.to eq("Fix requires for inflection related files") }
  its(:body) { is_expected.to start_with("Documented an issue") }

  describe "==" do
    let(:another_pull_request) {
      described_class.new(repo: "rails/rails", number: "23")
    }

    specify { expect(pull_request).to eq(another_pull_request) }
  end
end
