# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OnboardingInstructions::OnboardingInstructions, type: :component do
  subject { render_inline(described_class.new(**params)) }

  let(:user) { build(:user) }
  let(:params) { { user: user, token: 'TOKEN' } }

  it { should have_css('.OnboardingInstructions') }
end