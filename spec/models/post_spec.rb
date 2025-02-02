require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { build(:post) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_length_of(:comment).is_at_most(Post::MAX_COMMENT_LENGTH) }
    it { is_expected.to validate_length_of(:title).is_at_most(Post::MAX_TITLE_LENGTH) }
    it { is_expected.to validate_length_of(:tags).is_at_most(Post::MAX_TAGS) }
  end

  describe 'tags validation' do
    it 'allows nil tags' do
      post.tags = nil
      expect(post).to be_valid
    end

    it 'allows empty tags array' do
      post.tags = []
      expect(post).to be_valid
    end

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

  describe 'title validation' do
    it 'allows nil title' do
      post.title = nil
      expect(post).to be_valid
    end

    it 'allows blank title' do
      post.title = ''
      expect(post).to be_valid
    end

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

  describe 'comment validation' do
    it 'requires a comment' do
      post.comment = nil
      expect(post).not_to be_valid
      expect(post.errors[:comment]).to include("can't be blank")
    end

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

  describe 'timestamps' do
    let!(:post) { create(:post) }

    it 'sets created_at on creation' do
      expect(post.created_at).to be_present
    end

    it 'updates updated_at when modified' do
      original_time = post.updated_at
      travel 1.hour do
        post.update(comment: 'Updated comment')
        expect(post.updated_at).to be > original_time
      end
    end
  end
end
