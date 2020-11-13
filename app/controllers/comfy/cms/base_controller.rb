class Comfy::Cms::BaseController < ApplicationController

  before_action :load_cms_site

protected

  def load_cms_site
    puts "=====+++++ load_cms_site"
    @cms_site ||= if params[:site_id]
      puts "===== params[:site_id]"
      ap params[:site_id]
      ::Comfy::Cms::Site.find_by_id(params[:site_id])
    else
      puts "===== request.host_with_port.downcase"
      ap request.host_with_port.downcase

      puts "===== request.fullpath"
      ap request.fullpath

      ::Comfy::Cms::Site.find_site(request.host_with_port.downcase, request.fullpath)
    end
    puts "===== @cms_site"
    ap @cms_site 

    if @cms_site
      if @cms_site.path.present? && !params[:site_id]
        puts "===== @cms_site.path"
        ap @cms_site.path
        puts "===== params[:site_id]"
        ap params[:site_id]

        puts "===== params[:cms_path]"
        ap params[:cms_path]

        if params[:cms_path] && params[:cms_path].match(/\A#{@cms_site.path}/)
          params[:cms_path].gsub!(/\A#{@cms_site.path}/, '')
          params[:cms_path] && params[:cms_path].gsub!(/\A\//, '')
        else
          raise ActionController::RoutingError.new('Site Not Found')
        end
      end
      I18n.locale = @locale = @cms_site.locale.to_sym
    else
      I18n.locale = @locale = I18n.default_locale
      raise ActionController::RoutingError.new('Site Not Found')
    end

    puts "=====+++++ end load_cms_site"
  end

end