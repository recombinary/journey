module ConfigurationCache
  def self.pull
    @previous_config = Journey.configuration.clone
  end

  def self.push
    Journey.configuration = @previous_config if @previous_config
  end
end

