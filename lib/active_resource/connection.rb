require 'active_resource/connection'

module ActiveResource
  class Connection

    def handle_response(response)
      if response.respond_to?(:header) && (response.header["content-encoding"] == 'gzip')
        begin
          response.instance_variable_set('@body', ActiveSupport::Gzip.decompress(response.body))
        rescue Exception => e
          raise(BadRequest.new(response))
        end
      end

      case response.code.to_i
        when 301, 302, 303, 307
          raise(Redirection.new(response))
        when 200...400
          response
        when 400
          raise(BadRequest.new(response))
        when 401
          raise(UnauthorizedAccess.new(response))
        when 403
          raise(ForbiddenAccess.new(response))
        when 404
          raise(ResourceNotFound.new(response))
        when 405
          raise(MethodNotAllowed.new(response))
        when 409
          raise(ResourceConflict.new(response))
        when 410
          raise(ResourceGone.new(response))
        when 422
          raise(ResourceInvalid.new(response))
        when 401...500
          raise(ClientError.new(response))
        when 500...600
          raise(ServerError.new(response))
        else
          raise(ConnectionError.new(response, "Unknown response code: #{response.code}"))
      end
    end

  end
end
