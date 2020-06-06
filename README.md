# PCOE de Signage

This is a simple, web-based digital signage system that is written in Ruby on Rails. It has the following features:

**Content Types**

- A single image (poster)
- Text / HTML Markup
- LibCal All Schedules Slide
- Other custom slides

**Other Features**

- Default slide length
- Specific slide length per playlist
- Single or Dual Layout
- Rotate `90` or `270`
- LibCal Integration

![URL](https://github.com//CTC-PCOEdeSignage/PCOE-de-Signage-Rails/blob/master/documentation/example_screen.png?raw=true")

## Dependencies and Libraries

This project uses many open source projects to work:

- [Ruby on Rails](https://github.com/rails/rails)
- [Ruby 2.7.1](https://www.ruby-lang.org/en/)
- [Bootstrap 4](https://getbootstrap.com/)
- [Turbolinks](https://github.com/turbolinks/turbolinks)


## Data Model

The system has several concepts that are important to know, before logging in:

- *Screens* - `Screen` represents the physical screen which displays a `Playlist`. A screen has a name and has 1 or 2 rooms attached to it. The rotation setting is setup on a `Screen`.
- *Screen Layout* - Each Screen has a `layout` property which specifies whether it should be a `single` layout (i.e. one room attached) or `dual` layout (i.e. two rooms attached). If two rooms are attached, the order of screens (top and bottom) are defined on the screen.
- *Screen Rotation* - Each Screen has a `rotation` property which says whether it should be rotated `90` or `270` degrees.
- *Rooms* - A `Room` is physical space that represents the project or conference room. The room has a building/room number as well as a name. The name will show up
- *Playlist* - A `Playlist` is a list of `slides`, in a particular order, with a length attached to them. When editing a playlist, you can select select slides, change the slide order (via "Move"), change the length (in seconds), or delete a slide.
- *Slides* - A `Slide` represents a single slide of information. They can be pure images, HTML markup, or special slides that contain ruby code. See [How to Develop Custom Slides](#how-to-develop-custom-slides) for more information.
- *Slide Style* - A `Slide` has a property which specifies what type it is. There are three major types:
  - `markup` - which shows html markup; ONLY WHEN `markup` is specified will the markup text be used. NOTE: you can also include style tags or javascript, if needed, but be careful to keep these pages as simple as possible.
  - `image` - which shows a single image, centered on the screen. Images should be 1000 pixels high and 720 pixels wide at 72 DPI; ONLY WHEN `image` is specified will the image file be used. NOTE: Files should be JPG or GIF (pngs are supported, but load poorly). Images should also be optimized and cropped to be exactly 1000px X 720px
  - `other` - these are custom slides; The system looks in the server folder under `app/views/slides` for files ending in `.html.erb`; In the style selector for a slide, these will show up as the file name. NOTE: These slides may take longer to render if the . See [How to Develop Custom Slides](#how-to-develop-custom-slides) for more information.


## Other Helpful Links

- [LibCal Project Rooms](https://ohio-pattoncollege.libcal.com/booking/projectrooms)
- [LibCal Login](https://ohio-pattoncollege.libcal.com/admin/home?ali=1)


# How To Use

If a user knows the URL to the server, anyone can view the screen feed. Only administrators may login to the system to configure the displays, change the playlist order, remove or add slides, etc. For a vast majority of the administration, users will only need to use a web browser. However, in order to develop "Custom Slides" users will need physical or ssh access to the administrator server.


# Logging In

To login to the server, go to the the main web page for the server. See COE IT staff for the URL. From there, you may click on "Administrator Login". If you do not see that, consider appending "/admin" to the base url (e.g. http://webserver.coe.ohio.edu/admin)


## How To Develop Basic Slides

You can provide complex HTML pages (with style) by creating a new Slide (in the admin interface) with the `style` of markup. If you don't have complicated server-side generated code, you can simply create your own markup in the web interface. If you need special style, you can add `<style>` tags as appropriate. You can also include `<javascript>` if absolutely needed.

```html
<style>
  .head {
    padding-top: 200px;
  }

  h1 {
    color: red;
  }
</style>

<div class="grid">
  <div class="grid__col grid__col--12-of-12 center">
      <div class="head">
        <h1>Div</h1>
      </div>
  </div>
  <div class="grid__col grid__col--6-of-12 center">
    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</p>
  </div>
  <div class="grid__col grid__col--6-of-12 center">
    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</p>
  </div>
</div>
```

Note: We use the CSS grid library called Toast. Review the documentation there. https://daneden.github.io/Toast/


## How To Develop Custom Slides

You can provide server-side generated HTML pages by creating a file in in the root of the server, plus the subfolder `app/views/slides`. The file should start with `_` and end in `.html.erb`. (e.g. `app/views/slides/_example_page.html.erb`). This file can include, html, javascript, style, and now ERB (embedded ruby).

Once you've created the file, you may go into the admin interface and choose `Slide` -> `New Slide`. From the `style` dropdown select the new file and `name` the slide something similar. You can now use the slide in a playlist.

These custom slide files, when rendered by the server, are cached for 5 minutes before they are regenerated.

```erb
<div class="grid">
  <div class="grid__col grid__col--12-of-12 center">
      <div class="head">
        <h1><%= Time.current.to_s %></h1>
      </div>
  </div>
  <div class="grid__col grid__col--6-of-12 center">
    <p><%= ['a','b','c'].sample %></p>
  </div>
  <div class="grid__col grid__col--6-of-12 center">
    <p><%= ['x','y','z'].sample %></p>
  </div>
</div>
```


## Tips and Tricks

- When testing a specific slide, it may be useful to create a one-off playlist with only that slide so you can refresh and not
- Slides are cached for 5 minutes (important for custom slides), or when they change
- You can advance to the next slide (at any time) by hitting the right arrow key
- The displays will first `ping` the server before going to the next slide. If the server is down, it will stay on the same slide (indefinitely) until the server is available.


## Default Slide Change Time

By default, unless otherwise overridden on a per-playlist level, slides be shown for 30 seconds before advancing to the next slide. You can change the global default by editing the `.env` file in the project root and change the `DEFAULT_SLIDE_LENGTH` value.

Each `Playlist` has an option to change the slide length, per slide, as well.

NOTE: We do not recommend slide lengths less than 10 seconds.


## LibCal API Keys

The username/password to capture the LibCal-related information is stored in the `.env` keys under them
`LIBCAL_CLIENT_ID` and `LIBCAL_CLIENT_SECRET`. In order to change the keys in the future, edit the `.env` file and restart the server. If you need to change the keys, you may do so by creating new keys at  [https://ohio-pattoncollege.libcal.com/admin-only/api/authentication].


# Setup your Server

This guide assumes you have an Ubuntu 18.04 LTS box already setup. Instead of maintaining our own guide, we've found this helpful guide on [this gorails](https://gorails.com/setup/ubuntu/18.04). NOTE: You may skip the directions for "Setting Up MySQL, Setting Up PostgresSQL, and Final Steps". Also, our Ruby version is 2.7.1


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
RAILS_ENV=production
PORT=5000
RAILS_KEY_BASE=_value_from_below_
SMTP_SERVER="smtp.Office365.com"
SMTP_PORT="587"
SMTP_USERNAME="coe-projrms-sa@ohio.edu"
```

To determine `LIBCAL_CLIENT_ID` and `LIBCAL_CLIENT_SECRET`, you will need to follow the [directions above](#libcal-api-keys) and then place them in the file.

To generate a possible value for `RAILS_KEY_BASE`, run `bin/rails secret` and copy the contents from that command into your `.env` file.

Then run the following:

```
  bundle install # Upgrade and install all gems
  rails db:create # Create the database for the environment, if not already created
  rails db:migrate # Migrate the database
  ADMIN_EMAIL='test@ohio.edu' ADMIN_PASSWORD='securePassword' rails db:seed  # This creates an admin account; Please be sure to change the email and password
```

To change the port the server runs on, change the `PORT` value.

## Apache Config

This apache config may work for your needs. See [https://gist.github.com/abachman/851492] for details:

```xml
<VirtualHost *:80>
  ServerName server.name
  ServerAlias www.server.name

  ProxyPass / http://localhost:5000/
  ProxyPassReverse / http://localhost:5000/
</VirtualHost>

<VirtualHost *:443>
  ServerName server.name
  ServerAlias www.server.name

  SSLEngine on
  SSLOptions +StrictRequire
  SSLCertificateFile /opt/app/path/server.crt
  SSLCertificateKeyFile /opt/app/path/server.key

  SSLProxyEngine on                           #make sure apache knows SSL is okay to proxy
  RequestHeader set X_FORWARDED_PROTO 'https' #make sure Rails knows it was an SSL request
  ProxyPass / http://localhost:5000/          #NOTE: http not https
  ProxyPassReverse / http://localhost:5000/   #NOTE: http not https
</VirtualHost>
```


## Ubuntu Services

If you want to create a Ubuntu service to run the rails application, please do the following:

Stop the server if it's already running in another terminal window

Copy the following two files to ` /etc/systemd/system`. (
https://raw.githubusercontent.com/CTC-PCOEdeSignage/PCOE-de-Signage-Rails/master/documentation/services/pcoe-de-signage-app.service https://raw.githubusercontent.com/CTC-PCOEdeSignage/PCOE-de-Signage-Rails/master/documentation/services/pcoe-de-signage-master.service)

Edit the files to replace `User=service_user` with the appropriate username that rails will run as. NOTE: The users should have read/execute permissions on the rails application. You may also need to change the path to the user home directory. Lastly, we found that the `rbenv init` lines (from the ruby/rails setup) needed to be moved to the top of our `.bashrc` to allow them to be run in non-interactive mode.

Then do the following:

```sh
sudo chown root:root /etc/systemd/system/pcoe-de-signage-*.service # Change ownership
sudo chmod 0664 /etc/systemd/system/pcoe-de-signage-*.service # Change permissions
systemctl daemon-reload # Ask systemctl to look for new daemons
systemctl start pcoe-de-signage-master.service # Ask systemctl to start the master service
```

Check to make sure the service has started and the webserver is routing correctly.

If a problem appears to be happening, use `journalctl -u pcoe-de-signage-master.service` or `journalctl -u pcoe-de-signage-app.service` to see check the `systemctl` logs.

If all is working well, try a system restart to see if the server starts up at boot time.

## Updating

To update the server (from Github), you can run `bin/update` from the project root directory (likely `/opt/apps/PCOE-de-Signage-Rails`). Don't do this until you a) are instructed by the original developer of the software, or b) you have built a custom slide (and committed to Github) so that you can pull the latest down.

## Starting

To startup the server, you can run `bin/start`
