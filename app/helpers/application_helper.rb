module ApplicationHelper
  def ohio_image(color: :white)
    case color.to_sym
    when :white
      image_tag("OHIO_Patton_Logo_White.png", alt: "Ohio University", class: "img-fluid")
    when :black
      image_tag("OHIO_Patton_Logo_Black.gif", alt: "Ohio University", class: "img-fluid")
    else
    end
  end

  def patton_college_image
    image_tag("CalledToLead-Blue.gif", alt: "Patton College of Education", class: "img-fluid")
  end
end
