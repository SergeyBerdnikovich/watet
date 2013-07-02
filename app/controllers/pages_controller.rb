class PagesController < ApplicationController
  def welcome
  end

  def application
    flash[:notice] = 'applications are under development - coming soon!'
  end
end
