module Rack

  # Rack middleware for doing a find/replace on the response
  #
  # NOTE: The find/replace is applied to each chuck if the content is
  # streamed. This means if your pattern spans multiple chunks the
  # content will not be found.
  class Replace

    # Will setup the middleware so that all responses have a gsub
    # applied with the given args (and optional block)
    #
    #     use Rack::Replace, 'foo', 'bar'
    #     use Rack::Replace, 'foo' do
    #       'bar'
    #     end
    #
    # The only difference between how this call works and the normal
    # gsub is that IF you are using a block and IF that blocks takes
    # arguments then the first argument is the request environment.
    # The remaining arguments are the same as what gsub provides. So:
    #
    #     use Rack::Replace, 'hostname' do |env, match|
    #       env['HTTP_HOST']
    #     end
    def initialize(app, *args, &blk)
      @app = app
      @args = args
      @blk = blk
    end

    # Rack call interface
    def call(env) # :nodoc:
      status, headers, content = *@app.call(env)
      [status, headers, Response.new(content, env, *@args, &@blk)]
    end

  end
end

require 'rack/replace/response'
