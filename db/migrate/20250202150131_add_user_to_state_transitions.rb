class AddUserToStateTransitions < ActiveRecord::Migration[8.0]
  def change
    add_reference :state_transitions, :user, type: :uuid, foreign_key: true, null: true
  end
end
