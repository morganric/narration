class ProfilesController < ApplicationController
  before_action :set_profile, only: [:favorites, :about, :listens, :show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :about, :listens, :page, :popular, :favourites, :index]
  before_action :admin_only, :except => [:show, :about, :listens, :page, :popular, :edit, :favourites, :update]




  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @posts = Post.where(hidden: false).where(:user_id => @profile.user.id).order('created_at DESC').page params[:page]
  
  end

  def favorites
    @posts = @profile.user.favourites.where(hidden: false).order('created_at DESC').page params[:page]

  end

  def about

  end

  def listens

    @posts = @profile.user.listenings.where(hidden: false).page params[:page]

  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
     authorize @profile
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
     authorize @profile

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to vanity_profile_path(:id => @profile.user.name), notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def admin_only
      unless current_user && current_user.admin? 
        redirect_to :root, :alert => "Access denied."
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:user_id, :display_name, :image, :banner, :slug, :bio, :website, :twitter)
    end
end
