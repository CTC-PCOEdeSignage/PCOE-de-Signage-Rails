require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  let(:user) { build_stubbed(:user, email: "rb141412@ohio.edu") }
  let(:event) { build_stubbed(:event, user: user) }

  describe "validate_user" do
    let(:mail) { EventMailer.validate_user(event) }

    it "renders the headers" do
      expect(mail.subject).to include("Verification")
      expect(mail.to).to eq(["rb141412@ohio.edu"])
      expect(mail.from).to eq(["DoNotReply@ohio.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Verify!")
      expect(mail.body.encoded).to match("to verify")
    end
  end

  describe "approve" do
    let(:mail) { EventMailer.approve(event) }

    it "renders the headers" do
      expect(mail.subject).to include("Approve")
      expect(mail.to).to eq(["rb141412@ohio.edu"])
      expect(mail.from).to eq(["DoNotReply@ohio.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("request has been approved")
    end
  end

  describe "decline" do
    let(:mail) { EventMailer.decline(event) }

    it "renders the headers" do
      expect(mail.subject).to include("Decline")
      expect(mail.to).to eq(["rb141412@ohio.edu"])
      expect(mail.from).to eq(["DoNotReply@ohio.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("request has been declined.")
    end
  end

  describe "finish" do
    let(:mail) { EventMailer.finish(event) }

    it "renders the headers" do
      expect(mail.subject).to include("How was your event?")
      expect(mail.to).to eq(["rb141412@ohio.edu"])
      expect(mail.from).to eq(["DoNotReply@ohio.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("survey")
    end
  end

  describe "request_approval" do
    let!(:admin) { create(:admin_user, email: "glorious-admin@ohio.edu", receive_event_approvals: true) }
    let(:mail) { EventMailer.request_approval(event) }

    it "renders the headers" do
      expect(mail.subject).to include("Approve Event?")
      expect(mail.to).to eq(["glorious-admin@ohio.edu"])
      expect(mail.from).to eq(["DoNotReply@ohio.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Approve")
      expect(mail.body.encoded).to match("Decline")
    end
  end
end
