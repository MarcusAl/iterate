class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.text :comment, null: false
      t.string :title, limit: 255
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :project, type: :uuid, null: false, foreign_key: true
      t.string :tags, array: true, default: []

      t.timestamps
    end

    add_index :posts, :tags, using: 'gin'
    add_index :posts, :created_at
  end
end
