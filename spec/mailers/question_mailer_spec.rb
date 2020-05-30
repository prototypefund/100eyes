# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionMailer, type: :mailer do
  let(:question) { 'How do you do?' }
  describe 'new_message_email' do
    let(:mail) { QuestionMailer.with(message: message, to: 'test@example.org').new_message_email }
    let(:message) { 'Eine Nachfrage' }

    describe 'to' do
      subject { mail.to }
      it { should eq(['test@example.org']) }
    end

    describe 'subject' do
      subject { mail.subject }
      it { should eq('Die Redaktion hat eine Nachfrage an Sie') }
    end
  end

  describe 'new_question_email' do
    let(:mail) { QuestionMailer.with(question: question, to: 'test@example.org').new_question_email }

    describe 'subject' do
      subject { mail.subject }
      it { should eq('Die Redaktion hat eine neue Frage an Sie') }
    end

    describe 'to' do
      subject { mail.to }
      it { should eq(['test@example.org']) }
    end

    describe 'from' do
      subject { mail.from }
      it { should eq(['100eyes-test-account@example.org']) }
    end
  end
end
