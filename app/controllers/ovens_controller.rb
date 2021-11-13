class OvensController < ApplicationController
  before_action :authenticate_user!

  def index
    @ovens = current_user.ovens
  end

  def show
    @oven = current_user.ovens.find_by!(id: params[:id])
  end

  def empty
    @oven = current_user.ovens.find_by!(id: params[:id])
    if @oven.cookie
      @oven.cookie.update_attributes!(storage: current_user)
    end

    @oven.reload
    ActionCable.server.broadcast "oven_#{@oven.id}", {
      view: render(:partial => "ovens/cookie_info", :locals => {oven: @oven})
    }

    # Using the render method above to "cheat"
    # Set the response_body back to nil to prevent the DoubleRender exception
    # Hack found here: https://github.com/rails/rails/issues/25106
    self.response_body = nil
    @_response_body = nil

    redirect_to @oven, alert: 'Oven emptied!'
  end
end
