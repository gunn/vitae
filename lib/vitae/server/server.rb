require 'sinatra/base'

class Server < Sinatra::Base
  
  get '/' do
    "<ul>
      #{::CV.all.map do |cv|
        "<li>#{cv}</li>"
      end}
    </ul>"
    
  end
  
  
  
  @@project_root = nil
  def self.project_root
    @@project_root
  end
  
  def self.project_root= root
    @@project_root = root
  end
  
end
