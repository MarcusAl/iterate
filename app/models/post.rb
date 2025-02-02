# == Schema Information
#
# Table name: posts
#
#  id         :uuid             not null, primary key
#  comment    :text             not null
#  tags       :string           default([]), is an Array
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_posts_on_created_at  (created_at)
#  index_posts_on_project_id  (project_id)
#  index_posts_on_tags        (tags) USING gin
#  index_posts_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  include Sanitizable

  MAX_COMMENT_LENGTH = 2000
  MAX_TITLE_LENGTH = 255
  MAX_TAGS = 3

  belongs_to :user
  belongs_to :project

  validates :comment, presence: true, length: { maximum: MAX_COMMENT_LENGTH }
  validates :title, length: { maximum: MAX_TITLE_LENGTH }
  validates :tags, length: { maximum: MAX_TAGS }, allow_blank: true
end
