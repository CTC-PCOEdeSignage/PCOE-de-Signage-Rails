class SystemConfiguration
  class KeyNotFound < StandardError; end

  def self.get(*values)
    system_configuration.get(*values)
  end

  def self.system_configuration
    @system_configuration ||= new
  end

  def get(*values)
    values = values.map(&:to_s)

    loaded.dig(*values) || raise(KeyNotFound, values.join("->"))
  end

  def loaded
    @loaded ||= begin
        YAML.load(Rails.root.join("config", "system_configuration.yml").read)
      end
  end
end
