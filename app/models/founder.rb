# == Schema Information
#
# Table name: founders
#
#  id         :integer          not null, primary key
#  startup_id :integer
#  picture    :string
#  name       :string
#  title      :string
#  profile    :string
#  bio        :text
#  parsed_at  :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_founders_on_startup_id  (startup_id)
#

class Founder < ApplicationRecord
  belongs_to :startup
end
