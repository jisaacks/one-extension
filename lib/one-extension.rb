module OneExtension
  module ClassMethods
    attr_accessor :one_extension_type
    def one_extension(symbol)
      expecting = [:inclusion, :exclusion]
      unless expecting.include? symbol
        raise PathError, "expecting :inclusion or :exclusion: got `:#{symbol}`"
      end
      self.one_extension_type = symbol
    end
  end

  def self.included(base)
    base.send(:before_filter, :one_ext_check)
    base.extend(ClassMethods)
  end

  def one_ext_check
    # only run on get request for format.html
    is_get_request = request.env["REQUEST_METHOD"] == "GET"
    is_html_request = [nil, 'html'].include? request.filtered_parameters["format"]
    if is_get_request && is_html_request
      # check if the .html extension is set
      has_extension = request.env["PATH_INFO"][-5..-1] == ".html"
      # get the one_extension_type
      type = self.class.one_extension_type
      if type == :exclusion && has_extension
        # strip the .html
        url = request.env["PATH_INFO"][0...-5]
      elsif type == :inclusion && !has_extension
        # add the .html
        url = "#{request.env["PATH_INFO"]}.html"
      end
      if url.present?
        # put the query string back into the URL if present
        if request.env["QUERY_STRING"].length > 0
          url = "#{url}?#{request.env["QUERY_STRING"]}"
        end
        redirect_to url, :status => 301
      end
    end
  end
end

class ApplicationController < ActionController::Base
  include OneExtension
end