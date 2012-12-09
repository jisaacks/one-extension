module OneExtension
  def self.included(base)
    base.send(:before_filter, :one_ext_check)
  end
  def one_ext_check
    if request.env["REQUEST_METHOD"] == "GET" && 
       request.filtered_parameters["format"] == 'html'
      if request.env["PATH_INFO"][-5..-1] == ".html"
        url = request.env["PATH_INFO"][0...-5]
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