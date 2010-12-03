require 'sinatra/base'
require 'haml'

class Server < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/views'
  
  get '/' do
    @cvs = CV.all
    haml :index
  end
  
  get '/:name' do
    @cv = CV.find( params[:name] )
    haml :show
  end
  
  
  helpers do
    def link_to(name, link=nil, options={})
      link ||= name.split(/\s+/).join('_')
      attrs = options.map { |k,v| "#{k}='#{v}'" }.join(" ")
      "<a href='#{link}' #{attrs}>#{name}</a>"
    end
  end
  
  
  @@project_root = nil
  def self.project_root
    @@project_root
  end
  
  def self.project_root= root
    @@project_root = root
  end
  
end
