# PCOE de Signage

This is a simple, web-based digital signage system that is written in Ruby on Rails. It allows the following content to be used:

- A single image (poster)
- Text / HTML Markup
- LibCal All Schedules Slide
- Other custom slides

## Dependencies and Libraries

This project uses many open source projects to work:

- [Ruby on Rails](https://github.com/rails/rails)
- [Ruby 2.5.1](https://www.ruby-lang.org/en/)
- [SQLite3](https://www.sqlite.org/index.html)
- [Toast CSS](https://daneden.github.io/Toast/)
- [Turbolinks](https://github.com/turbolinks/turbolinks)

## Data Model

The system has several concepts that are important to know, before logging in:

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

## Other Helpful Links

- [LibCal Project Rooms](https://ohio-pattoncollege.libcal.com/booking/projectrooms)
- [LibCal Login](https://ohio-pattoncollege.libcal.com/admin/home?ali=1)

# How To Use

# Logging In

## How To Develop Custom Slides

You can provide complex HTML pages (with style) by creating a new Slide (in the admin interface) with the style of the

https://daneden.github.io/Toast/

## Tips and Tricks

- When testing a specific slide, it may be useful to create a one-off playlist with only that slide so you can refresh and not
- Slides are cached for 5 minutes (important for custom slides), or when they change
- You can advance to the next slide (at any time) by hitting the right arrow key

## Default Slide Change Time

By default, unless otherwise overridden on a per-playlist level, slides be shown for 30 seconds before advancing to the next slide. You can change the global default by editing the `.env` file in the project root and change the `DEFAULT_SLIDE_LENGTH` value.

Each `Playlist` has an option to change the slide length, per slide, as well.

NOTE: We do not recommend slide lengths less than 10 minutes.

## LibCal API Keys

The username/password to capture the LibCal-related information is stored in the `.env` keys under them
`LIBCAL_CLIENT_ID` and `LIBCAL_CLIENT_SECRET`. In order to change the keys in the future, edit the `.env` file and restart the server. If you need to change the keys, you may do so by creating new keys at  [https://ohio-pattoncollege.libcal.com/admin-only/api/authentication].

# Setup your Server

This guide assumes you have an Ubuntu 18.04 LTS box already setup. Instead of maintaining our own guide, we've found this helpful guide on [this gorails](https://gorails.com/setup/ubuntu/18.04). NOTE: You may skip the directions for "Setting Up MySQL, Setting Up PostgresSQL, and Final Steps". Also, our Ruby version is 2.5.1

## Configure

Once the base libraries have been setup, you'll need to do a few other steps:

Determine the location that you'd like to create the app and run it. Recommendation: `mkdir -p /opt/apps; cd /opt/apps`. `cd` to that directory.

Clone the repository `git clone git@github.com:CTC-PCOEdeSignage/PCOE-de-Signage-Rails.git`.

`cd PCOE-de-Signage-Rails`

In the root of the project, create a file called `.env` and have make it's contents the following:

```
LIBCAL_CLIENT_ID=
LIBCAL_CLIENT_SECRET=
DEFAULT_SLIDE_LENGTH=30 # Seconds
RAILS_ENV=RAILS_ENV=production
```

You will need to find the LibCal credentials (referenced elsewhere) and place them in the file.

Then run the following:

```
  bundle install # Upgrade and install all gems
  rails db:create # Create the database for the environment, if not already created
  rails db:migrate # Migrate the database
  ADMIN_EMAIL='test@ohio.edu' ADMIN_PASSWORD='securePassword' rails db:seed  # This creates an admin account; Please be sure to change the email and password
```

## Startup

To startup the server from that directory, you can run `bin/rails server --port 5000`

NOTE: You can control the port to be whatever is most relevant.
