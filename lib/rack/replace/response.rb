# Wraps around the response body applying the gsub expression as the
# content is extracted.
class Rack::Replace::Response

  # Wrap the content
  def initialize(content, env, *args, &blk) # :nodoc:
    @content = content
    @env = env
    @args = args
    @blk = blk
  end

  # Rack streaming interface
  def each # :nodoc:
    @content.each do |chunk|
      yield apply(chunk)
    end
  end

  # In case the content is some sort of IO interface
  def close # :nodoc:
    @content.close if @content.respond_to? :close
  end

  private

  # Actually apply the gsub expression
  def apply(chunk)
    chunk.gsub *@args do |*args|
      @blk.call @env, *args
    end
  end

end
