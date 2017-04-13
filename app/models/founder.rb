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
  has_many :links, class_name: 'FounderLink'

  accepts_nested_attributes_for :links

  def links_attributes=(arr)
    arr.each do |attributes|
      links.find_or_initialize_by(url: attributes[:url])
           .assign_attributes(attributes)
    end
  end
end
