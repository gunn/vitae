require "thor"

module Vitae
  class CLI < Thor
    include Thor::Actions
    
    def self.source_root
      File.expand_path('templates', File.dirname(__FILE__))
    end
    
    
    default_task :create

    desc "create [project_name]", "Create a new vitae project"
    def create(name, *cv_names)
      self.destination_root = name
      puts "creating #{name}..."
      
      copy_file "config.ru"
      
      if cv_names.size > 0
        cv_names.each do |cv_name|
          @name = cv_name
          @human_name = cv_name.split(/[^a-z]+/i).map{|w|w.capitalize}.join(" ")
          @url_name = @name.gsub(/[^a-z\-]+/i, "-")
          template "cvs/default.yaml.tt", "cvs/#{cv_name}.yaml"
        end
      else
        templates = Dir.glob(File.join(CLI.source_root, "cvs/*.yaml*")).
                        map{|f| File.basename(f)} -["default.yaml.tt"]
        
        templates.each do |template_name|
          template "cvs/#{template_name}", "cvs/#{template_name.sub(/\.tt$/, '')}"
        end
      end
      
      themes = Dir.glob(File.join(CLI.source_root, "themes/*")).map{|f| File.basename(f)}            
      themes.each do |theme_name|
        copy_file "themes/#{theme_name}/application.js"
        copy_file "themes/#{theme_name}/application.css"
      end
      
    end

    desc "server [-p 3000]", "Start the vitae server."
    def server(project_path=".")
      require "rack"
      just_pretend = ARGV.delete "--pretend"
      
      port_set_by_user = ARGV.any? { |a| %w[-p --port].include?( a ) }
      
      
      Vitae::project_root = File.expand_path(project_path, Dir.pwd)
      
      server = Rack::Server.new.tap do |s|
        s.options[:config]  = File.join(Vitae::project_root, "config.ru")
        s.options[:Port]    = 3141 unless port_set_by_user
      end
      
      
      
      opts = server.options
      cv_count = CV.all.size
      cvs = "#{cv_count} CV#{'s' unless cv_count==1}"
      project_dir_name = File.basename(Vitae::project_root)
      
      say "Serving #{cvs} at http://#{opts[:Host]}:#{opts[:Port]}/ from #{project_dir_name}\n", :green
      server.start unless just_pretend
    end
    
  end
end