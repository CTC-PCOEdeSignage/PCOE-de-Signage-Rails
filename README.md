# How To Use

## Logging in

## Data Model

The system has several concepts that are important to know:

- *Screens* - `Screen`s represent the physical screen which displays a `Playlist`. A screen has a name and has 1 or 2 rooms attached to it.
- *Screen Layout* - Each Screen has a `layout` property which specifies whether it should be a `single` layout (i.e. one room attached) or `dual` layout (i.e. two rooms attached). If two rooms are attached, the order of screens (top and bottom) are defined on the screen.
- *Screen Rotation* - Each Screen has a `rotation` property which says whether it should be rotated `90` or `270` degrees.
- *Rooms* - A `Room` is physical space that represents the project or conference room. The room has a building/room number as well as a name. The name will show up
- *Playlist* - A `Playlist` is a list of `slides`, in a particular order, with a length attached to them.
- *Slides* - A `Slide` represents a single slide of information. They can be pure images, HTML markup, or special slides that contain ruby code. See [How to Develop Custom Slides](#how-to-develop-custom-slides) for more information.
- *Slide Style* - A `Slide` has a property which specifies what type it is. There are three major types:
  - `markup` - which shows html markup; ONLY WHEN `markup` is specified will the markup text be used. NOTE: you can also include style tags or javascript, if needed, but be careful to keep these pages as simple as possible.
  - `image` - which shows a single image, centered on the screen. Images should be XX pixels high and XX pixels wide at 72 DPI; ONLY WHEN `image` is specified will the image file be used
  - `other` - these are custom slides; The system looks in the server folder under `app/views/slides` for files ending in `.html.erb`; In the style selector for a slide, these will show up as the file name. NOTE: These slides may take longer to render if the . See [How to Develop Custom Slides](#how-to-develop-custom-slides) for more information.

## How To Develop Custom Slides

You can provide complex HTML pages (with style) by creating a new Slide (in the admin interface) with the style of the

https://daneden.github.io/Toast/

## Tips and Tricks

- When testing a specific slide, it may be useful to create a one-off playlist with only that slide so you can refresh and not
- Slides are cached for 5 minutes (important for custom slides), or when they change
- You can advance to the next slide (at any time) by hitting the right arrow key

# Dependencies and Libraries

- [Ruby on Rails](https://github.com/rails/rails)
- [Ruby 2.5.1](https://www.ruby-lang.org/en/)
- [SQLite3](https://www.sqlite.org/index.html)
- [Toast CSS](https://daneden.github.io/Toast/)
- [Turbolinks](https://github.com/turbolinks/turbolinks)

# Setup

Setting up a full rails server is outside the scope of this document, however, you can use [this gorails guide](https://gorails.com/setup/ubuntu/16.04) to get started. NOTE: You may skip the directions for "Setting Up MySQL, Setting Up PostgresSQL, and Final Steps"

## Configure

Once the base has been setup, you'll need to do a few other steps:

Determine the location that you'd like to create the app and run it. `cd` to that directory.

Clone the repository `git clone git@github.com:CTC-PCOEdeSignage/PCOE-de-Signage-Rails.git`.

`cd PCOE-de-Signage-Rails`

In the root of the project, create a file called `.env` and add the following:

```
LIBCAL_CLIENT_ID=
LIBCAL_CLIENT_SECRET=
DEFAULT_SLIDE_LENGTH=30 # Seconds
RAILS_ENV=RAILS_ENV=production
```

Then run the following:
```
  bundle install # Upgrade and install all gems
  rails db:create # Create the database for the environment, if not already created
  rails db:migrate # Migrate the database
  ADMIN_EMAIL='test@ohio.edu' ADMIN_PASSWORD='securePassword' rails db:seed  # This creates an admin account; Please be sure to change the email and password
```

## Startup

To startup the server from that directory, you can run `bin/rails server --port 5000`

NOTE: You can control the port to be whatever is most revelant.
