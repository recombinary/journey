active_resource_logger = Logger.new('tmp/active_resource.log', 'daily')
active_resource_logger.level = Logger::DEBUG
ActiveResource::Base.logger = active_resource_logger
