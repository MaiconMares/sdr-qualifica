class ApplicationService
  def self.call(...)
    new(...).call
  end

  private

  def success(payload = nil)
    ServiceResult.new(success: true, payload: payload)
  end

  def failure(errors)
    errors = Array(errors)
    ServiceResult.new(success: false, errors: errors)
  end
end

class ServiceResult
  attr_reader :payload, :errors

  def initialize(success:, payload: nil, errors: [])
    @success = success
    @payload = payload
    @errors = errors
  end

  def success?
    @success
  end

  def failure?
    !@success
  end

  def error_message
    errors.join(", ")
  end
end
