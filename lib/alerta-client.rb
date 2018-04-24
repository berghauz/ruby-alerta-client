# encoding: utf-8
require 'net/http'
require 'uri'
require 'json'

class AlertaClient

    def initialize(host, key, env='Production')
	@env = env
	@host = host
	@header = {"Content-Type": "application/json", "Authorization": "Key #{key}"}
    end

    def heartbeat(origin, timeout=3600, tags=[])
	@uri = URI.parse("#{@host}/heartbeat")
	@body = { origin: origin, timeout: timeout, tags:tags}
    end

    # service - where it happend
    # resource - with what it happend
    # event - what happend, in short
    # value - value of happens, if applicable
    # text - what exactly happened, in detail
    def alert(service, resource, event, value, text, environment: @env, rawData: nil, severity: 'major', correlate: [], status: 'open', group: 'Misc', tags: [], attributes: {}, origin: nil, type: nil, timeout: 86400)
	@uri = URI.parse("#{@host}/alert")
	@body = {
	    service: service,
	    resource: resource,
	    event: event,
	    value: value,
	    text: text,
	    environment: environment,
	    rawData: rawData,
	    severity: severity,
	    correlate: correlate,
	    status: status,
	    group: group,
	    tags: tags,
	    attributes: attributes, 
	    origin: origin, 
	    type: type,
	    timeout: timeout
	}
    end
        
    def send()
	@http = Net::HTTP.new(@uri.host, @uri.port)
	@request = Net::HTTP::Post.new(@uri.request_uri, @header)
	@request.body = @body.to_json
	@response = @http.request(@request)
	if @response.code != '201'
	    return @response.code
	else
	    return nil
	end
    end

end
