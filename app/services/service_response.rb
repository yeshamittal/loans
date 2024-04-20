# frozen_string_literal: true

# Base class for generating response for service classes
class ServiceResponse
  attr_reader :status, :message, :http_status, :payload

  class << self
    def success(message: nil, payload: {}, http_status: :ok)
      new(status: :success, message: message, payload: payload, http_status: http_status)
    end

    def error(message:, payload: {}, http_status: :bad_request)
      new(status: :error, message: message, payload: payload, http_status: http_status)
    end
  end

  def initialize(status:, message: nil, payload: {}, http_status: nil)
    @status = status
    @message = message
    @payload = payload
    @http_status = http_status
  end

  def success?
    @status == :success
  end

  def error?
    @status == :error
  end

  def errors
    return [] unless error?

    Array.wrap(@message)
  end

  private

  attr_writer :status, :message, :http_status, :payload
end
