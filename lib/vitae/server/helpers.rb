module Helpers
  def current_theme
    @cv && @cv.theme || "default"
  end
  
  def include_theme_assets
    html = content_tag(:script, nil, :type => "text/javascript", :src => "/#{current_theme}/application.js")
    html << "\n"+tag(:link, nil, :type => "text/css", :media => "screen", :rel => "stylesheet", :href => "/#{current_theme}/application.css")
    html
  end
  
  def link_to(text, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    link = args.first || text.split(/\s+/).join('_').downcase
    content_tag :a, text, options.merge({:href => link})
  end
  
  def content_tag(*args, &block)
    args.last[:double_tag] = true if args.last.is_a?(Hash)
    tag(*args, &block)
  end
  
  def tag(*args, &block)
    name = args.first
    
    options = args.last.is_a?(Hash) ? args.pop : {}
    double_tag = options.delete(:double_tag)
    
    attrs = if options.size>0
      " "+options.map { |k,v| "#{k}='#{v}'" }.join(" ")
    else
      ""
    end
    tag_html = block_given? ? capture_html(&block) : args[1]
    
    "<#{name}#{attrs}"+(tag_html||double_tag ? ">#{tag_html}</#{name}>" : "/>")
  end
end