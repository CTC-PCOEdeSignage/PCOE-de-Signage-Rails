require "rails_helper"

RSpec.describe Markdown, :type => :service do
  it "Markdownify.render" do
    expect(Markdownify.render("**test**")).to eq("<p><strong>test</strong></p>\n")
  end
end
