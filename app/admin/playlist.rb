ActiveAdmin.register Playlist do
  permit_params :name, playlist_slides_attributes: [:id, :playlist_id, :slide_id, :position, :length, :_destroy]

  config.sort_order = 'name_asc'

  show do
    attributes_table do
      row :name
    end

    panel "Slides" do
      table_for playlist.playlist_slides do
        column :position
        column :name do |playlist_slide|
          link_to(playlist_slide.slide.name, admin_slide_path(playlist_slide.slide))
        end
        column :style do |playlist_slide|
          playlist_slide.slide.style
        end
        column "Length (seconds)" do |playlist_slide|
          playlist_slide.length
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end

    f.has_many :playlist_slides, heading: "Slides",
                                 sortable: :position,
                                 sortable_start: 1,
                                 allow_destroy: true do |ps|
      ps.input :slide
      ps.input :length
    end
    f.actions
  end

  index do
    selectable_column
    column :name
    column :updated_at
    actions
  end

end
