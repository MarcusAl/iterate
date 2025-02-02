# == Schema Information
#
# Table name: projects
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  priority    :integer          default(0), not null
#  status      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_projects_on_status  (status)
#
class Project < ApplicationRecord
  include AASM

  MAX_NAME_LENGTH = 255
  MAX_DESCRIPTION_LENGTH = 1000
  MIN_PRIORITY = 0
  MAX_PRIORITY = 5

  has_many :state_transitions, as: :trackable, dependent: :destroy
  validates :name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates :description, presence: true, length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :priority, inclusion: { in: MIN_PRIORITY..MAX_PRIORITY }

  aasm column: :status do
    state :draft, initial: true
    state :not_started
    state :in_progress
    state :completed
    state :cancelled

    event :start do
      transitions from: %i[draft not_started], to: :in_progress, after: :log_transition
    end

    event :complete do
      transitions from: :in_progress, to: :completed, after: :log_transition
    end

    event :cancel do
      transitions from: %i[draft not_started in_progress], to: :cancelled, after: :log_transition
    end
  end

  def timestamp_for_state(state)
    state_transitions.find_by(to_state: state)&.created_at
  end

  def state_history
    state_transitions.order(created_at: :asc)
  end

  private

  def log_transition
    state_transitions.create!(
      from_state: aasm.from_state,
      to_state: aasm.to_state,
      user: Current.user
    )
  end
end
