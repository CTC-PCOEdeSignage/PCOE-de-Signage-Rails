require "redcarpet"
require "redcarpet/render_strip"

class Markdownify
  def self.render(text)
    new.render(text)
  end

  def initialize(render_options = {}, extensions = {})
    @render_options = render_options
    @extensions = extensions
  end

  def render(text)
    markdown.render(text).html_safe
  end

  private

  def markdown
    Redcarpet::Markdown.new(renderer, extensions)
  end

  def renderer
    Redcarpet::Render::HTML.new(render_options)
  end

  def render_options
    {}.merge(@render_options)
  end

  def extensions
    {}.merge(@extensions)
  end
end
