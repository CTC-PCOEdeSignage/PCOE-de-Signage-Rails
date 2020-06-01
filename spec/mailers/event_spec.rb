require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  let(:user) { build_stubbed(:user, email: "rufus142@ohio.edu") }
  let(:event) { build_stubbed(:event, user: user) }

  describe "validate_user" do
    let(:mail) { EventMailer.validate_user(event: event) }

    it "renders the headers" do
      expect(mail.subject).to eq("Validate user")
      expect(mail.to).to eq(["rufus142@ohio.edu"])
      expect(mail.from).to eq(["no-reply@ohio.edu"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "approve" do
    let(:mail) { EventMailer.approve(event: event) }

    it "renders the headers" do
      expect(mail.subject).to eq("Approve")
      expect(mail.to).to eq(["rufus142@ohio.edu"])
      expect(mail.from).to eq(["no-reply@ohio.edu"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "decline" do
    let(:mail) { EventMailer.decline(event: event) }

    it "renders the headers" do
      expect(mail.subject).to eq("Decline")
      expect(mail.to).to eq(["rufus142@ohio.edu"])
      expect(mail.from).to eq(["no-reply@ohio.edu"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "pending" do
    let(:mail) { EventMailer.pending(event: event) }

    it "renders the headers" do
      expect(mail.subject).to eq("Pending")
      expect(mail.to).to eq(["rufus142@ohio.edu"])
      expect(mail.from).to eq(["no-reply@ohio.edu"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
