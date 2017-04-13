# == Schema Information
#
# Table name: startups
#
#  id          :integer          not null, primary key
#  title       :text
#  url         :string
#  description :text
#  status      :string
#  applicants  :string
#  location    :string
#  employees   :string
#  product     :text
#  why_us      :text
#  parsed_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Startup < ApplicationRecord
  has_many :links
  has_many :founders
  has_many :jobs

  accepts_nested_attributes_for :founders,
                                :jobs,
                                :links,
                                allow_destroy: true

  def self.add(arr)
    records = (arr - ids).map { |id| { id: id } }
    create(records) if records.any?
    records.count
  end

  def urls=(arr)
    arr.each do |url|
      links.find_or_initialize_by(url: url)
    end
  end

  def urls
    links.pluck(:url)
  end

  def founders_attributes=(arr)
    arr.each do |attributes|
      founders.find_or_initialize_by(name: attributes[:name])
              .assign_attributes(attributes)
    end
  end

  def jobs=(arr)
    arr.each do |attributes|
      jobs.find_or_initialize_by(url: attributes[:url])
          .assign_attributes(attributes)
    end
  end
end
