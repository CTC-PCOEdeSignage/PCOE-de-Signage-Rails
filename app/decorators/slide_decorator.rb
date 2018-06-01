class SlideDecorator < Draper::Decorator
  delegate_all

  def rendered_content
    case object.style.to_sym
    when :markup
      render_markup
    when :image
      return unless object.image.attached?
      render_image_tag
    else
      # Render the partial as a string
      render_slide_partial_as_string
    end
  end

  private

  def render_markup
    object.markup.html_safe
  end

  def render_image_tag
    h.image_tag(h.url_for(object.image))
  end

  def render_slide_partial_as_string
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(partial: "slides/#{object.style}").html_safe
  end
end
