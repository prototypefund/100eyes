# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Onboarding', type: :request do
  let(:contributor) { create(:contributor) }
  let(:jwt) { JsonWebToken.encode({ invite_code: 'ONBOARDING_TOKEN', action: 'onboarding' }) }
  let(:params) { { jwt: jwt } }

  describe 'GET /onboarding/index' do
    subject { -> { get onboarding_path(**params) } }

    it 'should be successful' do
      subject.call
      expect(response).to be_successful
    end

    describe 'with invalidated jwt' do
      let!(:invalidated_jwt) { create(:json_web_token, invalidated_jwt: 'INVALID_JWT') }
      let(:jwt) { 'INVALID_JWT' }

      it 'renders unauthorized page' do
        subject.call

        expect(response).not_to be_successful
      end
    end

    describe 'with jwt unsigned' do
      let(:jwt) { 'UNSIGNED_JWT' }

      it 'renders unauthorized page' do
        subject.call

        expect(response).not_to be_successful
      end
    end
  end
end
