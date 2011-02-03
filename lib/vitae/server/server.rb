require 'sinatra/base'
require 'haml'
require 'pdfkit'
require "vitae/server/helpers"
require "vitae/server/node"

class Server < Sinatra::Base
  helpers Helpers
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.join(Vitae::project_root, "themes") rescue ''
  
  before do
    request.path_info = CV.first.link if CV.size==1 && request.path_info=='/'
  end
  
  get '/' do
    @cvs = CV.all
    haml :index
  end
  
  get "/favicon.ico" do
    send_file File.join(File.dirname(__FILE__), "assets", "favicon.ico"), :type => 'image/x-icon', :disposition => 'inline'
  end
  
  get '/:path' do
    reload_nodes_module if ENV["RACK_ENV"]=="development"
    
    name, ext = params[:path].split('.')
    
    @cv = CV.find( name )
    
    case ext.to_s
    when '', 'html', 'htm'
      haml :show
    when 'yaml', 'yml'
      yaml_path = File.join(Vitae::project_root, "cvs", "#{@cv.file_name}.yaml")
      send_file yaml_path, :type => 'text/yaml', :disposition => 'inline'
    when 'pdf'
      content_type 'application/pdf', :charset => 'utf-8'

      pdf = PDFKit.new(haml(:show), :page_size => 'Letter', :print_media_type => true)
      pdf.stylesheets << File.join(Server::public, current_theme, "application.css")
      pdf.to_pdf
    else
      "Sorry, we don't have anything with a .#{ext} extension here."
    end
  end
  
  def reload_nodes_module
    warn "Reloading Nodes module"
    Vitae.send :remove_const, :Nodes if defined? Vitae::Nodes
    load File.join(File.dirname(__FILE__), "node.rb")
  end
  
end