class PostsController < ApplicationController
  before_action :set_post, only: [ :download, :miniembed, :show, :edit, :update, :destroy, :plays, :embed, :popout, :player]
  before_filter :authenticate_user!,  except: [:index, :miniembed, :show, :featured, :embed, 
                    :tag, :author, :provider, :popout, :latest, :plays]
   before_action :admin_only, :except => [:oembed, :embed, :miniembed, :destroy, :show, :page, :popular, :tag,
                :edit, :index, :favourites, :update, :featured, :popout, :latest, :provider, :author, :plays]

   require 'embedly'
  require 'json'
  include Curbit::Controller

after_filter :allow_iframe


  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where(hidden: false).order('plays DESC').page params[:page]
    @featured = Post.where(hidden: false).where(:featured => true).order('created_at DESC').limit(3)
    @new = Post.where(hidden: false).order('created_at DESC').page params[:page]
    @top = ActsAsTaggableOn::Tag.most_used(10)
    @listens = Listen.all.order('created_at DESC')
  end

  def latest
    @featured = Post.where(hidden: false).where(:featured => true).order('created_at DESC').limit(3)
    @posts = Post.where(hidden: false).order('created_at DESC').page params[:page]
    @top = ActsAsTaggableOn::Tag.most_used(10) 
    @listens = Listen.all.order('created_at DESC')
  end

  def tag
    @featured = Post.where(hidden: false).where(:featured => true).order('created_at DESC').limit(3)
    @tag = params[:tag]
    @posts = Post.where(hidden: false).tagged_with(@tag).page params[:page]  
    @top = ActsAsTaggableOn::Tag.most_used(10) 
    @listens = Listen.all.order('created_at DESC')
  end

  def featured
    @posts = Post.where(hidden: false).where(:featured => true).order('created_at DESC')
  end


  def download
    require 'open-uri'
    data = open(@post.audio_link) 
    send_data data.read, filename: "#{@post.slug}.mp3", type: "audio/mp3", disposition: 'attachment', stream: 'true', buffer_size: '4096' 
    
    @post.downloads = @post.downloads + 1
    @post.save

  end

  # GET /posts/1
  # GET /posts/1.json
  def show

    unless @post.listeners.blank?
      @posts = @post.listeners.first.favourites.page params[:page]
    end

  end

  def oembed
    @url = params[:url]

    require 'uri'

    @id = URI(@url).path.split('/').last

    @post = Post.friendly.find(@id)



    @post.html = "<iframe src='#{embed_url(:user_id => @post.user.name, :id => @post)}' frameborder='none' width='500' height='350'></iframe>"

    @json = Hash.new

    @json["html"] =  "<iframe src='#{embed_url(:user_id => @post.user.name, :id => @post)}' frameborder='none' width='500' height='350'></iframe>"


    @json = @json.to_json

    render layout: 'embed'

  end

  def author
    @author = params[:author]
    @posts = Post.where(hidden: false).where(:author => @author).page params[:page]
  end

  def provider
    @provider = params[:provider]
    @posts = Post.where(hidden: false).where(:provider => @provider).page params[:page]
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

  def miniembed
     render layout: 'embed'
  end

   def popout
     render layout: 'embed'
  end

  def player
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

  rate_limit :plays, :max_calls => 1, :time_limit => 30.seconds, :wait_time => 5.minute

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    unless @post.url.blank?
     embedly_api = Embedly::API.new :key => 'be7f3a535a974297b014470a23243df4'
     obj = embedly_api.oembed :url => post_params[:url]


     if params[:post][:title] == ""
        @post.title = obj[0].title
     end

     
     if params[:post][:summary] == ""
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
        format.html { redirect_to user_post_path(id: @post, user_id: @post.user.name), notice: 'Post was successfully updated.' }
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

    def admin_only
      unless current_user.admin? 
        redirect_to :root, :alert => "Access denied."
      end
    end

    
    def allow_iframe
      response.headers['X-Frame-Options'] = "ALLOWALL"
    end
    

    
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
