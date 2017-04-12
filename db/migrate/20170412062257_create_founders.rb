class CreateFounders < ActiveRecord::Migration[5.1]
  def change
    create_table :founders do |t|
      t.references :startup, foreign_key: true
      t.string :picture
      t.string :name
      t.string :title
      t.string :profile
      t.text :bio
      t.date :parsed_at

      t.timestamps
    end
  end
end
