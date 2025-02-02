class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.integer :priority, null: false, default: 0
      t.string :status, null: false

      t.timestamps
    end

    add_index :projects, :status
  end
end
