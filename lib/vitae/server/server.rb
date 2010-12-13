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
    @cv = CV.find( params[:name] )
    haml :show
  end
  
end