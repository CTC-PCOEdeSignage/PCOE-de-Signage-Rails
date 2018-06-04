ActiveAdmin.register Room do
  permit_params :name, :building, :room, :libcal_identifier

  config.sort_order = 'room_asc'

  form do |f|
    f.inputs do
      f.input :name
      f.input :building
      f.input :room
      f.input :libcal_identifier, label: "Libcal Room Identifier"
    end
    f.actions
  end

  index do
    selectable_column
    column :building
    column :room
    column :name
    column :libcal_identifier
    actions
  end

end
