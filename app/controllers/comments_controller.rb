class CommentsController < ApplicationController
	  skip_before_filter :require_login, :only => [:index]
	  before_filter :load_article

	def new
	  @comment = Comment.new(parent_id: params[:parent_id], article_id: params[:article_id], user_id: current_user[:id])
	end

	def create
	  if params[:comment][:parent_id].to_i > 0
	    parent = Comment.find_by_id(params[:comment].delete(:parent_id))
	    @comment = parent.children.build(comment_params)
	  else
	    @comment = Comment.new(comment_params)
	  end

	  if @comment.save
	    flash[:success] = 'Your comment was successfully added!'
	    redirect_to article_path(@article)
	  else
	    render 'new'
	  end
	end

	def edit
		@comment = Comment.find(params[:id])
	end

	def update
		@comment = Comment.find(params[:id])
		if @comment.update_attributes(comment_params)
      redirect_to article_path(@comment.article_id)
    else
      render :edit
    end
	end

	def upvote
		@comment = Comment.find(params[:comment_id])
		unless @comment.votes.where(user: current_user).exists?

	   @comment.votes.create(user: current_user)
	  else
	 	 flash[:notice] = "You can only vote once on another persons comment"
    end

    redirect_to article_path(params[:article_id])
	end

private

  def comment_params
    params.require(:comment).permit(:title, :body, :article_id, :user_id, :flagged)
  end

  def load_article
    @article = Article.find(params[:article_id])
  end
end
