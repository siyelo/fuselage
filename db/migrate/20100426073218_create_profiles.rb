class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :screen_name
      t.text :bio
      t.integer :age
      t.string :website_url
      t.text :interests
      t.text :hobbies
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :profiles
  end
end