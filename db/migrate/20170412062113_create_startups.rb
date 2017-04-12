class CreateStartups < ActiveRecord::Migration[5.1]
  def change
    create_table :startups do |t|
      t.text :title
      t.string :url
      t.text :description
      t.string :status
      t.string :applicants
      t.string :location
      t.string :employees
      t.text :product
      t.text :why_us
      t.datetime :parsed_at

      t.timestamps
    end
  end
end
