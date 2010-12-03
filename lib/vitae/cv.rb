class CV
  
  def self.all
    cv_dirs = Dir.entries(File.join(Server.project_root, "cvs")) - [".", "..", ".DS_Store"]
    cv_dirs.map do |dir|
      CV.new(dir)
    end
  end
  
  def self.find name
    all.find do |cv|
      cv.name == name
    end
  end
  
  def initialize dir
    @dir = dir
  end
  
  def name
    @dir
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
  
end