class Node
  include Haml::Helpers
  include Helpers
  
  attr_reader :level, :name, :data, :path
  
  def initialize(data, name=nil, level=1, parent_path=[])
    @data = data
    @name = name
    @level = level
    @path = parent_path << name
    
    init_haml_helpers
  end
  
  def to_s
    capture_haml do
      html
    end
  end
  
  def html
    haml_tag "h#{level}", name if name
    output_data
  end
  
  def output_data
    case data
    when Hash
      output_hash
    when Array
      haml_concat "Array!"
    else
      haml_concat data
    end
  end
  
  def output_hash
    data.each do |key, value|
      node_class = node_class_for_child(key, value)
      haml_concat node_class.new(value, key, level+1, path)
    end
  end
  
  def node_class_for_child(key, value)
    case key
    when /expertise/i then TagCloudNode
    else
      case (name && name.downcase)
      when "projects" then ProjectNode
      else Node
      end
    end
  end
end

class TagCloudNode < Node
  def html
    haml_tag "h#{level}", name
    haml_tag "ul#expertise.tags" do
      output_hash
    end
  end
  
  def output_hash
    data.each do |key, value|
      haml_tag "li.skill", key, :class => value
    end
  end
end

class ProjectNode < Node
  def html
    haml_tag "div.vevent.experience" do
      link = link_to(name, data["url"]) if data["url"]
      haml_tag "h#{level}" do
        haml_tag "span.location", (link||name)
        output_date_range
      end
    end
    haml_tag "b", data["role"]
    haml_tag "p", data["description"]
    # output_data
  end
  
  def output_date_range
    return unless data["start"] || data["end"]
    
    start_text = data["start"] ? data["start"].strftime("%B %Y") : nil
    end_text   = data["end"]   ? data["end"].strftime("%B %Y")   : "Present"
    
    haml_tag "span.dtrange" do
      haml_tag "span.dtstart", start_text, :title => data["start"] if start_text
      haml_concat "-"
      haml_tag "span.dtend", end_text, :title => data["end"] if end_text
    end
  end
end

# class NodeMap
#   def method_name
#     
#   end
#   
#   
#   def node_for_path path
#     VCardNode
#     ProjectNode
#     Node
#     
#     ["contact"], VCardNode
#     ["projects", "*"] => ProjectNode
#     ["*"] => Node
#     
#     Customer = Struct.new(:path, :node_class)
#   end
# end
