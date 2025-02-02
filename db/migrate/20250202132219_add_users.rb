class AddUsers < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :users, id: :uuid do |t|
      t.string :session_token, null: false
      t.boolean :admin, null: false, default: false
      t.timestamps
    end
    add_index :users, :session_token, unique: true
  end
end
