class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.references :user, foreign_key: true
      t.string :secret

      t.timestamps
    end
  end
end
