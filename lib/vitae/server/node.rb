class Node
  include Haml::Helpers
  include Helpers
  
  attr_reader :level, :name, :data, :path
  
  def self.types
    {
      "tag_cloud" => TagCloudNode,
      "project_list" => ProjectListNode,
      "project" => ProjectNode,
      "basic" => Node
    }
  end
  
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
    show_data
  end
  
  def output_data
    data.except(%w[node_type])
  end
  
  def show_data
    case output_data
    when Hash
      show_hash
    when Array
      haml_concat "Array!"
    else
      haml_concat data
    end
  end
  
  def show_hash
    output_data.each do |key, value|
      node_class = child_node_class(key, value)
      haml_concat node_class.new(value, key, level+1, path)
    end
  end
  
  def child_node_class_from_yaml(value)
    Node.types[value["node_type"]]
  end
  
  def child_node_class_from_name(name)
    case name
    when /expertise/i then TagCloudNode
    when /projects/i  then ProjectListNode
    else Node
    end
  end
  
  def child_node_class(key, value)
    child_node_class_from_yaml(value) || child_node_class_from_name(key)
  end
end

class TagCloudNode < Node
  def html
    haml_tag "h#{level}", name
    haml_tag "ul#expertise.tags" do
      show_hash
    end
  end
  
  def show_hash
    output_data.each do |key, value|
      haml_tag "li.skill", key, :class => value
    end
  end
end

class ProjectListNode < Node
  def show_hash
    haml_tag "ul.jobs-list.vcalendar" do
      output_data.each do |key, value|
        haml_concat ProjectNode.new(value, key, level+1, path)
      end
    end
  end
end

class ProjectNode < Node
  def html
    haml_tag "li.vevent.experience" do
      link = link_to(name, data["url"]) if data["url"]
      haml_tag "h#{level}" do
        haml_tag "span.location", (link||name)
        if data["role"]
          haml_concat " - "
          haml_tag "span.summary", data["role"]
        end
        show_date_range
      end
      
      haml_tag "p.job-description", data["description"]
    end
    # show_data
  end
  
  def show_date_range
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
