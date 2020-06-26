module ApplicationHelper
  def ohio_image(color: :white)
    case color.to_sym
    when :white
      image_tag("OHIO_Patton_Logo_White.png", alt: "Ohio University", class: "img-fluid", style: "height: 100px;")
    when :black
      image_tag("OHIO_Patton_Logo_Black.gif", alt: "Ohio University", class: "img-fluid", style: "height: 100px;")
    else
    end
  end

  def patton_college_image
    image_tag("CalledToLead-Blue.gif", alt: "Patton College of Education", style: "height: 100px;")
  end
end
