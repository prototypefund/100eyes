# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :issue
end
