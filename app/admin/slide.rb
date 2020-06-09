ActiveAdmin.register Slide do
  menu priority: 6

  permit_params :name, :style, :markup, :image

  config.sort_order = "name_asc"

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
      f.input :style, as: :select, collection: Slide::STYLE_OPTIONS
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
        s.decorate.rendered_content.call
      end
    end
  end

  index do
    selectable_column
    column :id
    column :name
    column :style
    column :updated_at
    actions
  end
end
