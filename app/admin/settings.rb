require "dry/schema"
require "fileutils"

ActiveAdmin.register_page "Settings" do
  class InvalidSchema < StandardError; end

  page_action :update, method: :post do
    @raw_yaml = params["settings"]["yaml"]

    settings = YAML.load(@raw_yaml)
    schema = Config.schema.call(settings.try(:deep_symbolize_keys))
    raise InvalidSchema, schema.errors(full: true).to_a.map(&:to_s).to_sentence unless schema.errors.empty?

    FileUtils.mkdir_p(Rails.root.join("config/settings"))
    File.write(Rails.root.join("config/settings/#{Rails.env}.yml"), @raw_yaml)
    Config.reload!
    redirect_to admin_settings_path, notice: "Settings Updated"
  rescue Psych::SyntaxError => e
    flash.now[:notice] = "Settings not updated: Invalid YAML syntax"
    render "admin/settings/show", layout: "active_admin"
  rescue InvalidSchema => e
    flash.now[:notice] = "Settings not updated: #{e.message}"
    render "admin/settings/show", layout: "active_admin"
  end

  content do
    render "admin/settings/update"
  end
end
