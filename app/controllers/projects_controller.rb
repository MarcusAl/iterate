class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    if params[:query].present?
      sanitized_query = params[:query].strip.gsub(/[^0-9A-Za-z\s]/, '').squish
      @projects = Project.keyword(sanitized_query)
    else
      @projects = Project.all
    end

    @pagy, @projects = pagy(@projects.order(created_at: :desc, name: :asc))
  end

  def show
    @pagy, @posts = pagy(@project.posts.includes(:user).order(created_at: :desc))
  end

  def new
    @project = Project.new
  end

  def edit; end

  def create; end

  def update; end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def search_params
    params.permit(:query, :page, :per_page, :id, :sort)
  end
end
