require "rails_helper"

RSpec.describe AdminUser, type: :model do
  subject { build_stubbed(:admin_user) }

  it { expect(subject.receive_event_approvals).to eq(false) }

  describe "scopes" do
    it ".receive_event_approvals" do
      create_list(:admin_user, 1, receive_event_approvals: false)
      create_list(:admin_user, 2, receive_event_approvals: true)

      users = AdminUser.receive_event_approvals
      expect(users.count).to eq(2)
      expect(users.map(&:receive_event_approvals)).to all(eq true)
    end
  end
end
