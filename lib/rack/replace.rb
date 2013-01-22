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
    #
    # You can optionally make the last argument a hash. If provided
    # those are the options to Rack::Replace.
    #
    # The only current option is :content_type which defaults to
    # 'text/html'. The content type of the response must match in
    # order for the gsub to take place. 
    def initialize app, *args, &blk
      @app = app
      @args = args
      @blk = blk

      @options = Hash === @args.last ? @args.pop : {}
      @options[:content_type] ||= 'text/html'
    end

    # Rack call interface
    def call env # :nodoc:
      status, headers, content = *@app.call(env)
      headers.delete 'Content-Length'
      content = Response.new(content, env, *@args, &@blk) if
        headers['Content-Type'] &&
        headers['Content-Type'].start_with?(@options[:content_type])
      [status, headers, content]
    end

  end
end

require 'rack/replace/response'
