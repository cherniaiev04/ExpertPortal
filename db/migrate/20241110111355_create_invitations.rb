class CreateInvitations < ActiveRecord::Migration[7.2]
  def change
    create_table :invitations do |t|
      t.string :token
      t.string :email
      t.datetime :expires_at
      t.boolean :used

      t.timestamps
    end
  end
end
