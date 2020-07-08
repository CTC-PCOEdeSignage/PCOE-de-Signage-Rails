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
      twelve_column_grid do
        object.markup.html_safe
      end
    end
  end

  def render_image_tag
    cached(:image) do
      twelve_column_grid(extra_classes: "image-slide") do
        h.image_tag("data:#{object.image.content_type};base64,#{base64_of_image}", height: "1000", width: "720")
      end
    end
  end

  def render_slide_partial_as_string
    cached(:partial, object.style, compute_md5_of_style) do
      view = ActionView::Base.new(ActionController::Base.view_paths, {})
      partial_path = "slides/#{object.style.match(/_(.*)/)[1]}"
      twelve_column_grid do
        view.render(partial: partial_path).html_safe
      end
    end
  end

  def cached(*keys)
    keys.push(object)
    Rails.cache.fetch(keys, expires_in: 1.minutes) do
      Rails.logger.info("[CACHE MISS] #{keys}")
      yield
    end
  end

  def twelve_column_grid(extra_classes: nil)
    h.content_tag(:div, class: "row") do
      h.content_tag(:div, class: "col-12 #{extra_classes}") do
        yield
      end
    end
  end

  def compute_md5_of_style
    filename = Slide::STYLES_PATH.join(object.style)
    Digest::MD5.hexdigest(File.read(filename))
  end

  def base64_of_image
    image_contents = object.image.download
    Base64.encode64(image_contents)
  end
end
