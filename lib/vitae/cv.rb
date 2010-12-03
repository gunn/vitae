class CV
  
  def self.all
    cvs = Dir.entries(File.join(Server.project_root, "cvs")) - [".", "..", ".DS_Store"]
    cvs.map do |cv|
      CV.new(cv)
    end
  end
  
  def self.find name
    all.find do |cv|
      cv.name == name
    end
  end
  
  def initialize yaml_file_name
    @name = yaml_file_name.sub(/\.yaml$/, '')
  end
  
  def name
    @name
  end
  
  def human_name
    name.split("_").map{|w|w.capitalize}.join(" ")
  end
  
  def to_s
    human_name
  end
  
  def link
    "/#{name}"
  end
  
  def theme
    "default"
  end
  
end