class Node
  include Haml::Helpers
  include Helpers

  attr_reader :level, :name, :data, :path

  class << self    
    def set(option, value=self, &block)
      value = block if block
      if value.kind_of?(Proc)
        define_method option, &value
      elsif value == self && option.respond_to?(:each)
        option.each { |k,v| set(k, v) }
      else
        set option, Proc.new{value}
      end
      self
    end

    def types
      {
        "simple_tag_cloud" => SimpleTagCloudNode,
        "tag_cloud" => TagCloudNode,
        "project_list" => ProjectListNode,
        "project" => ProjectNode,
        "base" => BaseNode,
        "standard" => Node
      }
    end
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
    case data
    when Hash
      show_hash
    when Array
      haml_concat "Array!"
    else
      haml_concat data
    end
  end

  def collection_wrapper &block
    return block.call unless collection_tag
    haml_tag collection_tag, &block
  end

  def node_wrapper &block
    return block.call unless node_tag
    haml_tag node_tag, &block
  end

  set :collection_tag => "ul", :node_tag => "li"

  def show_hash
    collection_wrapper do
      output_data.each do |key, value|
        node_class = child_node_class(key, value)
        node_wrapper do
          haml_concat node_class.new(value, key, level+1, path)
        end
      end
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
    child_node_class_from_yaml(value) || default_child_node_class || child_node_class_from_name(key)
  end
  set :default_child_node_class, nil

end

%w[ProjectNode TagCloudNode ProjectListNode BaseNode SimpleTagCloudNode].each do |class_name|
  Object.const_set(class_name, Class.new(Node))
end

class BaseNode < Node
  set :collection_tag, nil
  set :node_tag, nil
end

class TagCloudNode < Node
  set :collection_tag, "ul#expertise.tags"
  
  def show_hash
    collection_wrapper do
      output_data.each do |key, value|
        haml_tag "li.skill", key, :class => value
      end
    end
  end
end

class SimpleTagCloudNode < Node
  set :collection_tag, "ul#expertise.tags"
  
  def show_hash
    collection_wrapper do
      output_data.each_with_index do |(key, value), index|
        percent = ((output_data.size-index)/output_data.size.to_f)*70 + 75
        haml_tag "li.skill", key, :style => "font-size:#{percent}%;"
      end
    end
  end
end

class ProjectListNode < Node
  set :collection_tag, "ul.jobs-list.vcalendar"
  set :node_tag, "li.vevent.experience"
  set :default_child_node_class, ProjectNode
end

class ProjectNode < Node
  def html
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