class HomeController < ApplicationController
  def index
    render html: "<h1>Hello from Home#index</h1>".html_safe
  end
end
