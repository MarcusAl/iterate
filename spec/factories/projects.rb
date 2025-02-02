# == Schema Information
#
# Table name: projects
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  priority    :integer          default(0), not null
#  status      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_projects_on_status  (status)
#
FactoryBot.define do
  factory :project do
    name { "Project #{[0..9].sample}" }
    description { 'A test project description' }
    priority { Project::MIN_PRIORITY }

    trait :not_started do
      status { :not_started }
    end

    trait :in_progress do
      status { :in_progress }
    end

    trait :completed do
      status { :completed }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :high_priority do
      priority { Project::MAX_PRIORITY }
    end
  end
end
