# == Schema Information
#
# Table name: state_transitions
#
#  id             :uuid             not null, primary key
#  from_state     :string           not null
#  to_state       :string           not null
#  trackable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trackable_id   :uuid             not null
#  user_id        :uuid
#
# Indexes
#
#  index_state_transitions_on_trackable  (trackable_type,trackable_id)
#  index_state_transitions_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class StateTransition < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :user, optional: true

  validates :from_state, :to_state, presence: true
end
