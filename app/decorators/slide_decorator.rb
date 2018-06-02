class SlideDecorator < Draper::Decorator
  delegate_all

  def rendered_content
    case object.style.to_sym
    when :markup
      Proc.new { render_markup }
    when :image
      return unless object.image.attached?
      Proc.new { render_image_tag }
    else
      Proc.new { render_slide_partial_as_string }
    end
  end

  private

  def render_markup
    cached(:markup) do
      object.markup.html_safe
    end
  end

  def render_image_tag
    cached(:image) do
      h.image_tag(h.url_for(object.image))
    end
  end

  def render_slide_partial_as_string
    cached(:partial, object.style) do
      view = ActionView::Base.new(ActionController::Base.view_paths, {})
      view.render(partial: "slides/#{object.style}").html_safe
    end
  end

  def cached(*keys)
    keys.push(object)
    Rails.cache.fetch(keys, expires_in: 5.minutes) do
      Rails.logger.info("[CACHE MISS] #{keys}")
      yield
    end
  end
end
