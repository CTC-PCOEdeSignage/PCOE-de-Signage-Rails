ActiveAdmin.register Room do
  permit_params :name, :building, :room, :libcal_identifier

  form do |f|
    f.inputs do
      f.input :name
      f.input :building
      f.input :room
      f.input :libcal_identifier, label: "Libcal Room Identifier"
    end
    f.actions
  end

end
