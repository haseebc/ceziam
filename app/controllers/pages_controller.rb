class PagesController < ApplicationController
  
  skip_before_action :authenticate_user!, only: %i[home about glossary]

  def home; end

  def about; end

  def glossary; end

end
