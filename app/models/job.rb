# == Schema Information
#
# Table name: jobs
#
#  id           :integer          not null, primary key
#  url          :string
#  text         :text
#  compensation :text
#  startup_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_jobs_on_startup_id  (startup_id)
#

class Job < ApplicationRecord
  belongs_to :startup
end
