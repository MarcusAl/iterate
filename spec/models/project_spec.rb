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
require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }

  before do
    allow(Current).to receive(:user).and_return(user)
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:name).is_at_most(Project::MAX_NAME_LENGTH) }
    it { should validate_length_of(:description).is_at_most(Project::MAX_DESCRIPTION_LENGTH) }

    it 'validates priority is within range' do
      project = build(:project)

      expect(project).to validate_inclusion_of(:priority)
        .in_range(Project::MIN_PRIORITY..Project::MAX_PRIORITY)
        .with_message('is not included in the list')
    end
  end

  describe 'defaults' do
    it 'starts in draft state' do
      project = build(:project)
      expect(project.status).to eq('draft')
    end

    it 'has default priority of 0' do
      project = build(:project)
      expect(project.priority).to eq(0)
    end
  end

  describe 'state transitions' do
    let(:project) { create(:project) }

    context 'when starting a project' do
      it 'can transition from draft to in_progress' do
        expect(project.start!).to be true
        expect(project).to be_in_progress
      end

      it 'can transition from not_started to in_progress' do
        expect(project.may_start?).to be true
        expect(project.start!).to be true
        expect(project).to be_in_progress
      end

      it 'cannot transition from completed to in_progress' do
        project.start!
        project.complete!

        expect(project.may_start?).to be false
        expect { project.start! }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when completing a project' do
      it 'can transition from in_progress to completed' do
        project.start!
        expect(project.may_complete?).to be true
        expect(project.complete!).to be true
        expect(project).to be_completed
      end

      it 'cannot transition from draft to completed' do
        expect(project.may_complete?).to be false
        expect { project.complete! }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when cancelling a project' do
      it 'can be cancelled from draft state' do
        expect(project.may_cancel?).to be true
        expect(project.cancel!).to be true
        expect(project).to be_cancelled
      end

      it 'can be cancelled from not_started state' do
        project.start!
        expect(project.may_cancel?).to be true
        expect(project.cancel!).to be true
        expect(project).to be_cancelled
      end

      it 'can be cancelled from in_progress state' do
        project.start!
        expect(project.may_cancel?).to be true
        expect(project.cancel!).to be true
        expect(project).to be_cancelled
      end

      it 'cannot be cancelled from completed state' do
        project.start!
        project.complete!

        expect(project.may_cancel?).to be false
        expect { project.cancel! }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe 'state transition tracking' do
    let(:project) { create(:project) }

    it 'creates a state transition record when state changes' do
      expect do
        project.start!
      end.to change(StateTransition, :count).by(1)
    end

    it 'records the correct transition details' do
      project.start!
      transition = project.state_transitions.last

      expect(transition.from_state).to eq('draft')
      expect(transition.to_state).to eq('in_progress')
      expect(transition.user).to eq(user)
    end

    describe '#timestamp_for_state' do
      it 'returns nil for states never entered' do
        expect(project.timestamp_for_state('completed')).to be_nil
      end

      it 'returns the timestamp for entered states' do
        project.start!
        expect(project.timestamp_for_state('in_progress')).to be_present
      end
    end

    describe '#state_history' do
      it 'tracks mixed user and system changes' do
        allow(Current).to receive(:user).and_return(user)
        project.start!

        allow(Current).to receive(:user).and_return(nil)
        project.complete!

        history = project.state_history
        expect(history.count).to eq(2)
        expect(history.first.user).to eq(user)
        expect(history.second.user).to be_nil
      end
    end
  end

  describe 'scopes' do
    before do
      create(:project, status: :draft)
      create(:project, status: :in_progress)
      create(:project, :high_priority, status: :in_progress)
      create(:project, status: :completed)
      create(:project, status: :cancelled)
    end

    it 'has working state scopes' do
      expect(Project.draft.count).to eq(1)
      expect(Project.in_progress.count).to eq(2)
      expect(Project.completed.count).to eq(1)
      expect(Project.cancelled.count).to eq(1)
    end

    it 'allows combining multiple query conditions' do
      expect(Project.in_progress.where(priority: 5).count).to eq(1)
    end
  end
end
