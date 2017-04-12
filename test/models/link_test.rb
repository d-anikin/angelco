# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  url         :string
#  object_type :string
#  object_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_links_on_object_type_and_object_id  (object_type,object_id)
#

require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
