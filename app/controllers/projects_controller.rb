class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:state_transitions)
                       .order(created_at: :desc)

    return unless params[:query].present?

    @projects = @projects.search_by_name(params[:query])
  end

  private

  def project_params
    params.permit(:query, :page, :per_page)
  end
end
