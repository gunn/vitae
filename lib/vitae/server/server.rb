require 'sinatra/base'
require 'haml'
require "vitae/server/helpers"

class Server < Sinatra::Base
  helpers Helpers
  set :views, File.dirname(__FILE__) + '/views'
  
  get '/' do
    @cvs = CV.all
    haml :index
  end
  
  get '/:name' do
    @cv = CV.find( params[:name] )
    haml :show
  end
  
  
  
  @@project_root = nil
  def self.project_root
    @@project_root
  end
  
  def self.project_root= root
    set :public, File.join(root, "themes")
    @@project_root = root
  end
  
end