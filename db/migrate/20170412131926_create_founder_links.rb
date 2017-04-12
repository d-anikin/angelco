class CreateFounderLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :founder_links do |t|
      t.references :founder, foreign_key: true
      t.string :kind
      t.string :url

      t.timestamps
    end
  end
end
