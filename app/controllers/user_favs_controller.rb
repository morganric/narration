class UserFavsController < ApplicationController
	before_filter :authenticate_user!
	after_action :fav_email, only: :create
	# after_action :fav_action, only: :create
	# after_action :fav_tweet, only: :create

	def create
		@user_fav = UserFav.create(user_fav_params)

		respond_to do |format|
	      if @user_fav.save
	        format.js { redirect_to :back, as: :html, notice: 'Fav was successfully created.' }
	      else
	        format.js { redirect_to :back, as: :html, notice: 'Fav was not successfully created.' }
	      end
	    end
	end

	def destroy
		@user_fav = UserFav.where(user_fav_params)
		respond_to do |format|
	      if @user_fav.first.destroy
	        format.js { redirect_to :back, notice: 'Fav was successfully destroyed.' }
	      else
	        format.js { redirect_to :back, notice: 'Fav was not successfully destroyed.' }
	      end
	    end
	end

	def fav_email
		@profile = current_user.profile
		@post = Post.find(params[:user_fav][:post_id])
		UserMailer.favourite_email(@profile.user, @post).deliver
	end


  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_fav_params
      params.require(:user_fav).permit(:post_id, :user_id)
    end



end
