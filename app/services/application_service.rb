# frozen_string_literal: true

# Service wrapper for underlying services. They extend this class to be able to
# define `call`.
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
