ActiveAdmin.register Screen do
  permit_params :name, :rotation, :layout, :playlist_id, room_screens_attributes: [:id, :room_id, :screen_id, :position, :_destroy]

  form do |f|
    f.inputs do
      f.input :name
      f.input :rotation,  as: :select, collection: Screen.rotations
      f.input :layout,  as: :select, collection: Screen.layouts
      f.input :playlist_id,  as: :select, collection: Playlist.all
    end

    f.has_many :room_screens, heading: "Rooms",
                              sortable: :position,
                              sortable_start: 1,
                              allow_destroy: true do |a|
      a.input :room
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :rotation
      row :style
    end
    panel "Rooms" do
      table_for screen.room_screens do
        column :name do |room_screen|
          link_to(room_screen.room.name, admin_room_path(room_screen.room))
        end
        column :position
      end
    end
  end
end
