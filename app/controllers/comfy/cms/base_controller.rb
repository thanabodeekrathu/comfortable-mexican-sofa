# frozen_string_literal: true

class Comfy::Cms::BaseController < ComfortableMexicanSofa.config.public_base_controller.to_s.constantize

  before_action :load_cms_site

  helper Comfy::CmsHelper

protected

  def load_cms_site
    puts "=====+++++----- cms/base_controller.rb"
    @cms_site ||=
      if params[:site_id]
        puts "=====+++++----- site id"

        ap params[:site_id]
        ::Comfy::Cms::Site.find_by_id(params[:site_id])
      else
        puts "=====+++++----- host_with_port"
        ap request.host_with_port.downcase

        puts "=====+++++----- fullpath"
        ap request.fullpath
        ::Comfy::Cms::Site.find_site(request.host_with_port.downcase, request.fullpath)
      end
    puts "=====+++++----- cms_site"
    ap @cms_site

    if @cms_site
      if @cms_site.path.present? && !params[:site_id]
        puts "=====+++++----- params[:cms_path]"
        ap params[:cms_path]

        puts "=====+++++----- @cms_site.path"
        ap @cms_site.path

        if params[:cms_path]&.match(%r{\A#{@cms_site.path}})
          params[:cms_path].gsub!(%r{\A#{@cms_site.path}}, "")
          params[:cms_path]&.gsub!(%r{\A/}, "")
        else
          raise ActionController::RoutingError, "Site Not Found"
        end
      end
    else
      raise ActionController::RoutingError, "Site Not Found"
    end
    puts "=====+++++----- end cms/base_controller.rb"

  end

end
