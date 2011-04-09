Bundler.require :default, :development

require 'test/unit'
require 'rack/mock'

class ReplaceTest < Test::Unit::TestCase

  def server(&blk)
    app = Rack::Builder.new do
      instance_eval &blk
      run proc {|env| [200, {}, ['Hello world']]}
    end.to_app
    @mock = Rack::MockRequest.new app
  end

  def test_simple
    server {use Rack::Replace, 'world', 'universe'}
    assert_equal 'Hello universe', @mock.get('/').body
  end

  def test_back_reference
    server {use Rack::Replace, /(\w+) (\w+)/, '\2 \1'}
    assert_equal 'world Hello', @mock.get('/').body
  end

  def test_block
    server {use(Rack::Replace, /\w+/) {|env, match| match.reverse}}
    assert_equal 'olleH dlrow', @mock.get('/').body
  end

  def test_env
    server {use(Rack::Replace, /world/) {|env, match| env['SERVER_NAME']}}
    assert_equal 'Hello example.org', @mock.get('/').body
  end

end
