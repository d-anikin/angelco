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
end
