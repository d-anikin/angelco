class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.string :url
      t.references :object, polymorphic: true

      t.timestamps
    end
  end
end
