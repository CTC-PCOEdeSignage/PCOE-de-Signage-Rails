ActiveAdmin.register Slide do
  permit_params :name, :style, :markup, :image

  form do |f|
    f.inputs do
      f.input :name
      f.input :style, as: :select, collection: Slide.styles
      f.input :markup
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :style
      row :content do |s|
        s.decorate.rendered_content
      end
    end
  end

end
