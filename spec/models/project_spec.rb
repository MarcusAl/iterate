# frozen_string_literal: true

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

require 'rails_helper'

RSpec.describe Post do
  describe 'associations' do
    let(:post) { create(:post) }

    it 'belongs to a user' do
      expect(post.user).to be_present
    end

    it 'belongs to a project' do
      expect(post.project).to be_present
    end
  end

  describe 'validations' do
    let(:post) { build(:post) }

    it 'requires a comment' do
      post.comment = nil
      expect(post).not_to be_valid
      expect(post.errors[:comment]).to include("can't be blank")
    end

    it 'limits comment length' do
      post.comment = 'A' * (Post::MAX_COMMENT_LENGTH + 1)
      expect(post).not_to be_valid
      expect(post.errors[:comment]).to include('is too long (maximum is 2000 characters)')
    end

    it 'limits title length' do
      post.title = 'A' * (Post::MAX_TITLE_LENGTH + 1)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include('is too long (maximum is 255 characters)')
    end

    it 'limits number of tags' do
      post.tags = %w[tag1 tag2 tag3 tag4]
      expect(post).not_to be_valid
      expect(post.errors[:tags]).to include('is too long (maximum is 3 characters)')
    end
  end

  describe 'tags validation' do
    let(:post) { build(:post) }

    context 'when tags are empty or nil' do
      it 'allows nil tags' do
        post.tags = nil
        expect(post).to be_valid
      end

      it 'allows empty tags array' do
        post.tags = []
        expect(post).to be_valid
      end
    end

    context 'when tags are present' do
      it 'allows maximum of three tags' do
        post.tags = %w[tag1 tag2 tag3]
        expect(post).to be_valid
      end

      it 'rejects more than three tags' do
        post.tags = %w[tag1 tag2 tag3 tag4]
        expect(post).not_to be_valid
        expect(post.errors[:tags]).to include('is too long (maximum is 3 characters)')
      end
    end
  end

  describe 'title validation' do
    let(:post) { build(:post) }

    context 'when title is empty or nil' do
      it 'allows nil title' do
        post.title = nil
        expect(post).to be_valid
      end

      it 'allows blank title' do
        post.title = ''
        expect(post).to be_valid
      end
    end

    context 'when title is present' do
      it 'allows title within maximum length' do
        post.title = 'A' * Post::MAX_TITLE_LENGTH
        expect(post).to be_valid
      end

      it 'rejects title exceeding maximum length' do
        post.title = 'A' * (Post::MAX_TITLE_LENGTH + 1)
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include('is too long (maximum is 255 characters)')
      end
    end
  end

  describe 'comment validation' do
    let(:post) { build(:post) }

    context 'when comment is not present' do
      it 'rejects nil comment' do
        post.comment = nil
        expect(post).not_to be_valid
        expect(post.errors[:comment]).to include("can't be blank")
      end
    end

    context 'when comment is present' do
      it 'allows comment within maximum length' do
        post.comment = 'A' * Post::MAX_COMMENT_LENGTH
        expect(post).to be_valid
      end

      it 'rejects comment exceeding maximum length' do
        post.comment = 'A' * (Post::MAX_COMMENT_LENGTH + 1)
        expect(post).not_to be_valid
        expect(post.errors[:comment]).to include('is too long (maximum is 2000 characters)')
      end
    end
  end

  describe 'timestamps' do
    let(:post) { create(:post) }

    it 'sets created_at on creation' do
      expect(post.created_at).to be_present
    end

    it 'updates updated_at when modified' do
      original_time = post.updated_at
      travel 1.hour do
        post.update!(comment: 'Updated comment')
        expect(post.updated_at).to be > original_time
      end
    end
  end
end
