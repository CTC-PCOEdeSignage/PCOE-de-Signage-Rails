RSpec.shared_examples "accessible" do
  it "should be accessible" do
    expect(page).to be_accessible
  end
end

RSpec.shared_examples "event details" do |event_var_name|
  it "should contain event details" do
    event = send(event_var_name)

    expect(page).to have_content(event.purpose)
    expect(page).to have_content(event.start_at.to_formatted_s(:long))
  end
end

RSpec.shared_examples "duration optionable" do |factory_class|
  describe "#duration_options" do
    subject { build(factory_class) }
    it "should be an array" do
      expect(subject.duration_options).to be_an Array
    end
  end

  describe "#duration_options_hash" do
    subject { build(factory_class) }

    before do
      subject.duration_options = [15, 30, 45]
      subject.save
      subject.reload
    end

    it "should be a Hash" do
      expect(subject.duration_options_hash).to be_a Hash
    end

    it "should include each option" do
      expect(subject.duration_options_hash).to include "15 minutes" => 15
      expect(subject.duration_options_hash).to include "30 minutes" => 30
      expect(subject.duration_options_hash).to include "45 minutes" => 45
    end
  end

  describe "#duration_options_string" do
    subject { build(factory_class) }

    it "should be a string" do
      expect(subject.duration_options_string).to be_a String
    end

    it "should allow getting" do
      subject.duration_options = [1, 2, 3]
      expect(subject.duration_options_string).to eq("1,2,3")
    end
    it "should allow setting" do
      subject.duration_options_string = "1,2,3"
      expect(subject.duration_options).to eq [1, 2, 3]

      subject.duration_options_string = "1 , 2 , 3"
      expect(subject.duration_options).to eq [1, 2, 3]
    end
  end
end
