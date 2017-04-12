# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  url        :string
#  startup_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_links_on_startup_id  (startup_id)
#

class Link < ApplicationRecord
  belongs_to :startup
end
