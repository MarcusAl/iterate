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
FactoryBot.define do
  factory :post do
    association :user
    association :project

    title { 'Sample Post Title' }
    comment { 'Sample post comment' }
    tags { [] }

    trait :with_tags do
      tags { %w[tag1 tag2] }
    end

    trait :with_long_comment do
      comment { 'A' * 1000 }
    end
  end
end
