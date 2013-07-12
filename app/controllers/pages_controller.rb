class PagesController < ApplicationController
  def welcome
  end

  def application
    flash[:notice] = t 'application.in_dev'
  end
end
