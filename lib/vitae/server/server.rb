require 'sinatra/base'
require 'haml'
require "vitae/server/helpers"
require "vitae/server/node"

class Server < Sinatra::Base
  helpers Helpers
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.join(Vitae::project_root, "themes") rescue ''
  
  get '/' do
    @cvs = CV.all
    haml :index
  end
  
  get "/favicon.ico" do
    send_file File.join(File.dirname(__FILE__), "assets", "favicon.ico"), :type => 'image/x-icon', :disposition => 'inline'
  end
  
  get '/:name' do
    reload_nodes_module if ENV["RACK_ENV"]=="development"
    
    @cv = CV.find( params[:name] )
    haml :show
  end
  
  def reload_nodes_module
    warn "Reloading Nodes module"
    Vitae.send :remove_const, :Nodes if defined? Vitae::Nodes
    load File.join(File.dirname(__FILE__), "node.rb")
  end
  
end