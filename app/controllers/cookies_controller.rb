class CookiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    if @oven.cookie
      redirect_to @oven, alert: 'A cookie is already in the oven!'
    else
      @cookie = @oven.build_cookie
    end
  end

  def create
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    @cookie = @oven.create_cookie!(cookie_params)

    ActionCable.server.broadcast "oven_#{@oven.id}", {
      view: render(:partial => "ovens/cookie_info", :locals => {oven: @oven})
    }

    # Using the render method above to "cheat"
    # Set the response_body back to nil to prevent the DoubleRender exception
    # Hack found here: https://github.com/rails/rails/issues/25106
    self.response_body = nil
    @_response_body = nil

    redirect_to oven_path(@oven)
  end

  private

  def cookie_params
    params.require(:cookie).permit(:fillings)
  end
end
