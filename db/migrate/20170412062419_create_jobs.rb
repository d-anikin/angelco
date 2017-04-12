class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.string :url
      t.text :text
      t.text :compensation
      t.references :startup, foreign_key: true

      t.timestamps
    end
  end
end
