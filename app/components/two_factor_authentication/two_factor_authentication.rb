# frozen_string_literal: true

module TwoFactorAuthentication
  class TwoFactorAuthentication < ApplicationComponent
    def initialize(user: nil, qr_code: nil)
      super

      @user = user
      @qr_code = qr_code
    end

    private

    attr_reader :user, :qr_code

    def qr_code_as_svg
      # rubocop:disable Rails/OutputSafety
      qr_code.as_svg.html_safe
      # rubocop:enable Rails/OutputSafety
    end
  end
end
