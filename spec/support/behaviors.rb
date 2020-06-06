RSpec.shared_examples "accessible" do
  it "should be accessible" do
    expect(page).to be_accessible
  end
end
