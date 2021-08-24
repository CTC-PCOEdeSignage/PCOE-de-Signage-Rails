ActiveAdmin.register Room do
  menu priority: 4

  permit_params :name, :building, :room, :duration_options_string

  config.sort_order = "room_asc"

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names

    f.inputs do
      f.input :name
      f.input :building
      f.input :room
      f.input :duration_options_string, label: "Duration Options"
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :building
    column :room
    column :name
    actions
  end
end
