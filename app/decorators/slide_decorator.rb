class SlideDecorator < Draper::Decorator
  delegate_all

  def rendered_content
    case object.style.to_sym
    when :markup
      object.markup.html_safe
    when :image
      return unless object.image.attached?

      h.image_tag(h.url_for(object.image))
    else
      h.content_tag(:div) do
        "<p>Another Style; TODO</p>".html_safe
      end
    end
  end
end
