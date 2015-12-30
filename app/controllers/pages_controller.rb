class PagesController < ApplicationController

	 layout 'paper'

def welcome

    @posts = Post.where(:featured => true).order('created_at DESC')
  end

end
