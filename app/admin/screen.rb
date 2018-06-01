ActiveAdmin.register Screen do
  permit_params :name, :rotation, :layout, :playlist_id

  form do |f|
    f.inputs do
      f.input :name
      f.input :rotation,  as: :select, collection: Screen.rotations
      f.input :layout,  as: :select, collection: Screen.layouts
      f.input :playlist_id,  as: :select, collection: Playlist.all
    end
    f.actions
  end
end
