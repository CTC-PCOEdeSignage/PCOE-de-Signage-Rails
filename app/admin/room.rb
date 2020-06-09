ActiveAdmin.register Room do
  menu priority: 4

  permit_params :name, :building, :room

  config.sort_order = "room_asc"

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
      f.input :building
      f.input :room
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
