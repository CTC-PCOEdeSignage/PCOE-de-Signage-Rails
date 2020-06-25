class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  validates_inclusion_of :receive_event_approvals, in: [true, false]

  validates :password_confirmation, presence: true, on: :create

  scope :receive_event_approvals, -> { where(receive_event_approvals: true) }

  def password_required?
    !persisted? || !password.blank? || !password_confirmation.blank?
  end
end
