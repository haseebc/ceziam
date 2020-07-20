class PagesController < ApplicationController
  
  skip_before_action :authenticate_user!, only: %i[home about glossary healthcheck]

  def home; end

  def about; end

  def glossary; end

  def healthcheck; end

end
