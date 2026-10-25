# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.date :date_of_birth, null: false
      t.string :role, null: false, default: "user"
      t.datetime :suspended_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
