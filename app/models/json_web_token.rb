# frozen_string_literal: true

class JsonWebToken < ApplicationRecord
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload)
    exp_payload = { data: payload, exp: 48.hours.from_now.to_i }
    JWT.encode(exp_payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
  end
end