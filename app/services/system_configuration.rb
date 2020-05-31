class SystemConfiguration
  class KeyNotFound < StandardError; end

  CONFIG_FILE_PATH = Rails.root.join("config", "system_configuration.yml")

  def self.get(*values)
    system_configuration.get(*values)
  end

  def self.system_configuration
    @system_configuration ||= new
  end

  def get(*values)
    values = values.map(&:to_s)

    from_cache(*values) || raise(KeyNotFound, values.join("."))
  end

  private

  def from_cache(*values)
    Rails.cache.fetch(values.join(".")) do
      from_yaml(values)
    end
  end

  def from_yaml(values)
    yaml.dig(*values)
  end

  def yaml
    @loaded ||= YAML.load(CONFIG_FILE_PATH.read)
  end
end
