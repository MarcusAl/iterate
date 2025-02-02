class CreateStateTransitions < ActiveRecord::Migration[8.0]
  def change
    create_table :state_transitions, id: :uuid do |t|
      t.references :trackable, polymorphic: true, type: :uuid, null: false
      t.string :from_state, null: false
      t.string :to_state, null: false

      t.timestamps
    end
  end
end
