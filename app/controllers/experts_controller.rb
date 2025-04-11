class ExpertsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_access_index, only: %i[index]
  before_action :set_variables, only: %i[new create edit update]
  before_action :set_expert, only: %i[show edit update destroy upload_cv upload_certificates delete_cv delete_certificate]
  before_action :ensure_access_new_create, only: %i[new create]
  before_action :ensure_access_edit_update, only: %i[edit update]
  before_action :ensure_access_show, only: %i[show]
  before_action :ensure_access_destroy, only: %i[destroy]

  # GET /experts or /experts.json
  def index
    @experts = Expert.includes(:categories).all

    # Apply search filter
    if params[:query].present?
      query = params[:query].downcase
      @experts = @experts.where("LOWER(firstname) LIKE :query OR LOWER(name) LIKE :query", query: "%#{query}%")
    end

    # Apply advanced filters
    if params[:filters].present?
      if params[:filters][:communication_language].present?
        @experts = @experts.where(
          params[:filters][:communication_language].map { |_| "EXISTS (SELECT 1 FROM json_each(communication_language) WHERE value = ?)" }.join(" AND "),
          *params[:filters][:communication_language]
        )
      end

      if params[:filters][:lesson_language].present?
        @experts = @experts.where(
          params[:filters][:lesson_language].map { |_| "EXISTS (SELECT 1 FROM json_each(lesson_language) WHERE value = ?)" }.join(" AND "),
          *params[:filters][:lesson_language]
        )
      end

      if params[:filters][:travel_willingness].present?
        @experts = @experts.where(
          params[:filters][:travel_willingness].map { |_| "EXISTS (SELECT 1 FROM json_each(travel_willingness) WHERE value = ?)" }.join(" AND "),
          *params[:filters][:travel_willingness]
        )
      end
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end



  # GET /experts/1 or /experts/1.json
  def show
    @category = @expert.categories
  rescue ActiveRecord::RecordNotFound
    redirect_to experts_path, alert: I18n.t('experts.errors.expert_not_found')
  end

  # GET /experts/me
  def me
    if current_user.role == 'expert' && current_user.expert_id.present?
      redirect_to expert_path(current_user.expert_id)
    elsif current_user.role == 'expert'
      redirect_to new_expert_path, alert: I18n.t('users.errors.not_initiated')
    else
      redirect_to experts_path
    end
  end

  # GET /experts/new
  def new
    @expert = Expert.new
    @categories = Category.active
    @cancel_path = experts_path
    @save_text = I18n.t('general.create')
  end

  # GET /experts/1/edit
  def edit
    @categories = Category.active
    @cancel_path = expert_path(@expert)
    @save_text = I18n.t('general.save')
  end

  # POST /experts or /experts.json
  def create
    @expert = Expert.new(expert_params)
    @categories = Category.active
    @save_text = I18n.t('general.create')

    respond_to do |format|
      if @expert.save
        # Update categories association
        @expert.categories = Category.where(id: params[:expert][:category_ids])

        # If this expert is being created during user registration, associate the expert and mark as initiated.
        current_user.update(expert: @expert, initiated: true) unless current_user.initiated?
        format.html { redirect_to @expert, notice: I18n.t('experts.messages.created') }
        format.json { render :show, status: :created, location: @expert }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experts/1 or /experts/1.json
  def update
    @expert = Expert.find(params[:id])
    @categories = Category.active
    @save_text = I18n.t('general.create')

    @expert.cv.purge if params[:expert][:cv_to_remove].present?

    if params[:expert][:certificates_to_remove].present?
      params[:expert][:certificates_to_remove].each do |certificate_id|
        if (certificate = @expert.certificates.find_by(id: certificate_id))
          certificate.purge
        end
      end
    end

    certificates = params[:expert][:certificates] if params[:expert]
    expert_params_filtered = expert_params.except(:certificates)

    respond_to do |format|
      if @expert.update(expert_params_filtered)
        if certificates.present?
          cleaned_certificates = certificates.reject(&:blank?)
          @expert.certificates.attach(cleaned_certificates) if cleaned_certificates.any?
        end

        if params[:expert][:category_ids].present?
          @expert.categories = Category.where(id: params[:expert][:category_ids])
        else
          @expert.categories.clear
        end

        format.html { redirect_to @expert, notice: I18n.t('experts.messages.updated') }
        format.json { render :show, status: :ok, location: @expert }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experts/1 or /experts/1.json
  def destroy
    @expert.destroy!

    respond_to do |format|
      format.html { redirect_to experts_path, status: :see_other, notice: I18n.t('experts.messages.destroyed') }
      format.json { head :no_content }
    end
  end

  # POST /experts/:id/upload_cv
  def upload_cv
    if params[:file].present?
      @expert.cv.attach(params[:file])
      if @expert.cv.attached?
        render json: { id: @expert.cv.id, filename: @expert.cv.filename.to_s }, status: :ok
      else
        render json: { error: "Failed to upload CV" }, status: :unprocessable_entity
      end
    else
      render json: { error: "No file provided for CV" }, status: :bad_request
    end
  end

  # POST /experts/:id/upload_certificates
  def upload_certificates
    if params[:files].present?
      attached_files = []
      params[:files].each do |file|
        @expert.certificates.attach(file)
        attached_files << { id: @expert.certificates.last.id, filename: @expert.certificates.last.filename.to_s }
      end
      render json: attached_files, status: :ok
    else
      render json: { error: "No files provided for certificates" }, status: :bad_request
    end
  end

  # DELETE /experts/:id/delete_cv
  def delete_cv
    if @expert.cv.attached?
      @expert.cv.purge
      render json: { message: "CV deleted successfully" }, status: :ok
    else
      render json: { error: "CV not found" }, status: :not_found
    end
  end

  # DELETE /experts/:id/delete_certificate
  def delete_certificate
    certificate = @expert.certificates.find_by(id: params[:certificate_id])

    if certificate
      certificate.purge
      render json: { message: "Certificate deleted successfully" }, status: :ok
    else
      render json: { error: "Certificate not found" }, status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_variables
    @salutations = I18n.t('experts.salutations')
    @travels = I18n.t('experts.travel_willingnesses')
    @expert_languages = I18n.t('experts.expert_languages')
  end

  def set_expert
    @expert = Expert.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to experts_path, alert: I18n.t('experts.errors.not_found')
  end

  # Only allow a list of trusted parameters through.
  def expert_params
    params.require(:expert).permit(:name, :firstname, :email, :institution_bool, :institution, :expertise, :additionalInfo, :salutation, :location,
                                   :title, :telephone, :nationality, :dailyRate, :hourlyRate, :expInChina, :travel_info, :short_term_availability, :cv, communication_language: [], travel_willingness: [], lesson_language: [], category_ids: [])
  end

  # Allowed only to admin and user
  def ensure_access_index
    return if current_user.present? && %w[admin user].include?(current_user.role)

    redirect_to me_experts_path, alert: I18n.t('users.errors.no_access')
  end

  # Allowed to admin and user, experts are only allowed on their own page
  # This also handles the experts/me
  def ensure_access_show
    return unless current_user.role == 'expert'
    return if current_user.expert_id == @expert&.id

    if current_user.initiated?
      redirect_to me_experts_path, alert: I18n.t('users.errors.not_your_expert')
    else
      redirect_to new_expert_path, alert: I18n.t('users.errors.not_initiated')
    end
  end

  # Allow access to admin and experts with initiated == false
  def ensure_access_new_create
    if current_user.nil? || current_user.role == 'expert' && current_user.initiated?
      redirect_to me_experts_path, alert: I18n.t('users.errors.already_initiated')
    elsif current_user.nil? || current_user.role == 'user'
      redirect_to experts_path, alert: I18n.t('users.errors.no_access')
    end
  end

  # Allow access to admin and expert whose expert_id matches @expert.id
  def ensure_access_edit_update
    if current_user.nil? || current_user.role == 'user'
      redirect_to experts_path, alert: I18n.t('users.errors.no_access')
    elsif current_user.role == 'expert' && current_user.expert_id != @expert&.id
      if current_user.initiated == true
        redirect_to me_experts_path, alert: I18n.t('users.errors.not_your_expert')
      else
        redirect_to new_expert_path, alert: I18n.t('users.errors.not_initiated')
      end
    end
  end

  # Allow access to admin
  def ensure_access_destroy
    if current_user.nil? || current_user.role == 'user'
      redirect_to experts_path, alert: I18n.t('users.errors.no_access')
    elsif current_user.role == 'expert'
      redirect_to me_experts_path, alert: I18n.t('users.errors.no_delete_access')
    end
  end
end
