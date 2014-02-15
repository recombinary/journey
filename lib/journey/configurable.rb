require 'journey/configuration'
require 'logger'

module Journey
  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.configuration=(configuration)
    @@configuration = configuration
    @@configuration.propagate!
  end

  def self.configure(attributes = {})
    configuration = Configuration.new(attributes)
    yield(configuration) if block_given?
    self.configuration = configuration
  end

  def self.logger=(logger)
    @@logger = logger
    ActiveResource::Base.logger = logger
  end

  def self.logger
    @@logger
  end

  self.logger = Logger.new(STDOUT)
  self.logger.level = Logger::WARN
end
