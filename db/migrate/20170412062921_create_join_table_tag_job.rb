class CreateJoinTableTagJob < ActiveRecord::Migration[5.1]
  def change
    create_join_table :tags, :jobs do |t|
      # t.index [:tag_id, :job_id]
      # t.index [:job_id, :tag_id]
    end
  end
end
