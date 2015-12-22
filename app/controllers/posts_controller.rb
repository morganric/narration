class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :plays, :embed, :popout]
  before_filter :authenticate_user!,  except: [:index, :show, :tag, :featured, :embed, :tag, :author, :provider, :popout]
  

   require 'embedly'
  require 'json'


  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order('plays DESC').page params[:page]
    @featured = Post.where(:featured => true) 
    @new = Post.all.order('created_at DESC').page params[:page]
  end

  def tag
    @tag = params[:tag]
    @posts = Post.tagged_with(@tag)    
  end

  def featured

    @posts = Post.where(:featured => true)    
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  def author
    @author = params[:author]
    @posts = Post.where(:author => @author)
  end

  def provider
    @provider = params[:provider]
    @posts = Post.where(:provider => @provider)
  end

  # GET 

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
     authorize @post
  end

  def embed
     render layout: 'embed'
  end

   def popout
     render layout: 'embed'
  end


  def plays

    @post.plays = @post.plays.to_i + 1
    @post.save

    respond_to do |format|
     if @post.save
       format.json { render :show, status: :ok, location: @post }
     else
       format.html { render action: 'new' }
       format.json { render json: @post.errors, status: :unprocessable_entity }
     end
    end

  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    unless @post.url.blank?
     embedly_api = Embedly::API.new :key => 'be7f3a535a974297b014470a23243df4'
     obj = embedly_api.oembed :url => post_params[:url]
     @post.title = obj[0].title
     if @post.summary == ""
        @post.summary =  obj[0].description
     end
     @post.provider = obj[0].provider_name
      @post.provider_url = obj[0].provider_url
      @post.author = obj[0].author_name
      @post.author_url = obj[0].author_url
    end
    @post.user_id = current_user.id
    @post.plays = 0

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
     authorize @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :url, :audio, :audio_link, :summary, :image, :user_id, :slug, 
        :plays, :banner, :tag_list, :hidden, :featured, :html, :body, :author, :author_url, :provider, :provider_url)
    end
end
