require "yaml"

class CV
  attr_reader :file_name
  
  class << self
    def all
      raise "Vitae::project_root is not set" unless Vitae::project_root
      cvs = Dir.glob(File.join(Vitae::project_root, "cvs/*.yaml"))
      cvs.map do |cv|
        CV.new(cv)
      end
    end

    def find file_name
      all.find do |cv|
        cv.file_name == file_name
      end
    end
    
    def first
      all.first
    end
    
    def last
      all.last
    end
  end
  
  def initialize yaml_file
    @yaml_file = yaml_file
    @file_name = File.basename(yaml_file, '.yaml')
  end
  
  
  def name
    @name ||=  data_hash.delete("name")
  end
  
  def vitae_config
    @vitae_config ||=  data_hash.delete("vitae_config")
  end
  
  def data_hash
    @data_hash ||= YAML::load_file(@yaml_file)
  end
  
  def [] key
    data_hash[key]
  end
  
  def except exceptions=[]
    data_hash.except( exceptions )
  end
  
  def each &block
    data_hash.each do |k, v|
      yield k, v
    end
  end
  
  
  def link
    "/#{file_name}"
  end
  
  def theme
    "default"
  end
  
  def to_s
    name
  end
  
  # def method_missing name, *args, &block
  #   data.send name, *args, &block
  # end
  
end