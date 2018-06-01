ActiveAdmin.register Slide do
  permit_params :name, :style, :markup

  form do |f|
    f.inputs do
      f.input :name
      f.input :style, as: :select, collection: Slide.styles
      f.input :markup
    end
    f.actions
  end

end
