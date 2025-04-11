class CourseModulesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_course_module, only: %i[show edit update destroy]

      # GET /course_modules
  def index
    @course_modules = CourseModule.active
    @course_modules_inactive = CourseModule.archived
  end

  # GET /course_modules/new
  def new
    @course_module = CourseModule.new
  end

  # GET /course_modules/1/edit
  def edit; end

  # POST /course_modules
  def create
    @course_module = CourseModule.new(course_module_params)

    respond_to do |format|
      if @course_module.save
        format.html { redirect_to course_modules_path, notice: I18n.t('course_modules.messages.created') }
        format.json { render :show, status: :created, location: @course_module }
      end
    end
  end

 # PATCH/PUT /course_modules/1 or /course_modules/1.json
 def update
    respond_to do |format|
      if @course_module.update(course_module_params)
        format.html { redirect_to course_modules, notice: I18n.t('course_modules.messages.updated') }
        format.json { render :show, status: :ok, location: @course_module }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_module.errors, status: :unprocessable_entity }
      end
    end
  end

 # DELETE /course_modules/1 or /course_modules/1.json
 def destroy
    @course_module = CourseModule.find(params[:id])
    if @course_module.experts.exists?
      @course_module.soft_delete
      redirect_to course_modules_path, notice: I18n.t('course_modules.errors.soft_deleted')
    else
      @course_module.destroy
      redirect_to course_modules_path, notice: I18n.t('course_modules.errors.hard_deleted')
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_course_module
    @course_module = CourseModule.find(params[:id])
  end

# Only allow a list of trusted parameters through.
  def course_module_params
    params.require(:course_module).permit(:name)
  end
end
