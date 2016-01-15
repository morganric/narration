class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User

    @plays = 0
    @embeds = 0

    @posts = Post.all

    @posts.each do |post|
        @plays = @plays.to_i + post.plays.to_i
        @embeds = @embeds.to_i + post.embeds.to_i
    end

    @favs = UserFav.all

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "WEEjsCutsC9zZc18oT48y4InW"
      config.consumer_secret     = "7kadn2WN1MWqicMZKXDzycCqhnscrAOWsPgEYfOBvO9IH7fBUP"
      config.access_token        = "16663910-RiT45kEy0w703fXXCGn8ZoTKuCfQL23DhviKRbGUX"
      config.access_token_secret = "q7gw1Ptw2Dahix2hgAXk1hZrADCSxU3sw91TQaLXyt4jf"
    end

    @tweets = @client.search("narrated.org")


  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def secure_params
    params.require(:user).permit(:role, :name, :unsubscribe)
  end

end
