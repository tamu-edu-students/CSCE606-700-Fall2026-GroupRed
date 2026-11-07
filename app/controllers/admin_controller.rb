class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :admin, :show?
  end
end
