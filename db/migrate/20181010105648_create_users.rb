class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :authorization_code #temporary code returned by MONZO after directed back from auth
      t.string :access_token #this will be temporary and encrypted on receiving, and need to be decrypted when sent to front end for fetch requests frontend side

      t.timestamps
    end
  end
end
