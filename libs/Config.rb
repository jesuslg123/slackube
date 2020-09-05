require 'yaml'

class Config

  def initialize(path)
    load_config(path)
  end

  def status_list 
    @config["status"]
  end

  def token
    @config["slack"]["token"]
  end

  def mqtt_host
    @config["mqtt"]["host"]
  end

  def mqtt_port
    @config["mqtt"]["port"]
  end

  def mqtt_topic
    @config["mqtt"]["topic"]
  end

  private

  def load_config(path)
    @config = YAML.load_file(path)

    puts "*********************"
    puts @config.inspect
    puts "*********************"
  end

end