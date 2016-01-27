class SettingsController < ApplicationController


  before_filter :authenticate_user!
   before_action :admin_only


def index
    # to get all items for render list
    @settings = Settings.all
  end

  def edit
    @settings = Settings.unscoped
  end

  def update
	  # params.each_pair do |setting, value|

	  #   eval("Settings.#{setting} = #{value}")
	  # end

	  Settings.all.each do |setting|

	  	setting.value = params[setting.var]
	  	setting.save
	  end

	  redirect_to settings_path, :notice => 'Settings updated' # Redirect to the settings index
	end


  private

    def admin_only
      unless current_user.admin? 
        redirect_to :root, :alert => "Access denied."
      end
    end


end
