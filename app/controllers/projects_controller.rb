class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, except: %i[show index]
  before_action :ensure_staff, only: %i[show index]
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects or /projects.json
  def index
    @projects = Project.all

    if params[:query].present?
      query = params[:query].downcase
      @projects = @projects.where("LOWER(name) LIKE ?", "%#{query}%")
    end

    if params[:filters].present?
      if params[:filters][:expertise].present?
        @projects = @projects.where(expertise: params[:filters][:expertise])
      end

      if params[:filters][:key_topics].present?
        @projects = @projects.select do |project|
          (project.key_topics & params[:filters][:key_topics]).any?
        end
      end

      if params[:filters][:location].present?
        @projects = @projects.select do |project|
          (project.location & params[:filters][:location]).any?
        end
      end
    end

    @expertise_values = Project.distinct.pluck(:expertise).compact
    @key_topics_values = Project.distinct.pluck(:key_topics).flatten.uniq.compact
    @location_values = Project.distinct.pluck(:location).flatten.uniq.compact

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end



  # GET /projects/1 or /projects/1.json
  def show
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new(location: [], project_type: [], key_topics: [])
    @experts = Expert.all
    @cancel_path = projects_path
    @save_text = I18n.t("general.create")
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @experts = Expert.all
    @cancel_path = project_path(@project)
    @save_text = I18n.t("general.save")
    @project.location ||= []
    @project.project_type ||= []
    @project.key_topics ||= []
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @experts = Expert.all

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: I18n.t('projects.messages.created_success') }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    @experts = Expert.all
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: I18n.t('projects.messages.refreshed_success') }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, status: :see_other, notice: I18n.t('projects.messages.deleted_success') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(
        :name,
        :schedule,
        :time_period_start,
        :time_period_end,
        :participants,
        :clients,
        :expertise,
        location: [],
        project_type: [],
        key_topics: [],
        expert_ids: []
      )
    end
end
