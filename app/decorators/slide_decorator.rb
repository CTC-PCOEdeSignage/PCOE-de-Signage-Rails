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
      twelve_column_grid do
        h.image_tag(h.url_for(object.image))
      end
    end
  end

  def render_slide_partial_as_string
    cached(:partial, object.style, compute_md5_of_style) do
      view = ActionView::Base.new(ActionController::Base.view_paths, {})
      partial_path = "slides/#{object.style.match(/_(.*)/)[1]}"
      view.render(partial: partial_path).html_safe
    end
  end

  def cached(*keys)
    keys.push(object)
    Rails.cache.fetch(keys, expires_in: 5.minutes) do
      Rails.logger.info("[CACHE MISS] #{keys}")
      yield
    end
  end

  def twelve_column_grid
    h.content_tag(:div, class: "grid") do
      h.content_tag(:div, class: "grid__col grid__col--12-of-12") do
        yield
      end
    end
  end

  def compute_md5_of_style
    filename = Slide.styles_path.join(object.style)
    Digest::MD5.hexdigest(File.read(filename))
  end
end
