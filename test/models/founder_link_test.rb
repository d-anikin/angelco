# == Schema Information
#
# Table name: founder_links
#
#  id         :integer          not null, primary key
#  founder_id :integer
#  kind       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_founder_links_on_founder_id  (founder_id)
#

require 'test_helper'

class FounderLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
