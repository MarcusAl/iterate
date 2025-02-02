class PostsController < ApplicationController
  before_action :set_project
  before_action :set_post, only: %i[edit update destroy]
  before_action :authorize_post, only: %i[edit update destroy]

  def create
    @post = @project.posts.build(post_params)
    @post.user = current_user

    @post.title = Post.sanitize_string(@post.title)
    @post.comment = Post.sanitize_text(@post.comment)
    @post.tags = Post.sanitize_array(@post.tags)

    if @post.save
      flash[:success] = 'Post was successfully created.'
      redirect_to @project
    else
      flash[:error] = @post.errors.full_messages.join(', ')
      redirect_to @project
    end
  end

  def update
    sanitized_params = {
      title: Post.sanitize_string(post_params[:title]),
      comment: Post.sanitize_text(post_params[:comment]),
      tags: Post.sanitize_array(post_params[:tags])
    }

    if @post.update(sanitized_params)
      flash[:success] =
        'Post was successfully updated.'
    else
      flash[:error] =
        @post.errors.full_messages.join(', ')
    end
    redirect_to @project
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post was successfully deleted.'
    redirect_to @project
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_post
    @post = @project.posts.find(params[:id])
  end

  def authorize_post
    return if @post.user == current_user

    flash[:error] = 'You are not authorized to perform this action.'
    redirect_to @project
  end

  def post_params
    params.require(:post).permit(:title, :comment, tags: [])
  end
end
