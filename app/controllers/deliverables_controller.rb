class DeliverablesController < ApplicationController
  load_and_authorize_resource
  before_action :set_deliverable, only: [:show, :edit, :update, :destroy]

  # GET /deliverables
  # GET /deliverables.json
  def index
    @deliverables = Deliverable.all
  end

  # GET /deliverables/1
  # GET /deliverables/1.json
  def show
  end

  # GET /deliverables/new
  def new
    @deliverable = Deliverable.new
  end

  # GET /deliverables/1/edit
  def edit
  end

  # POST /deliverables
  # POST /deliverables.json
  def create
    @deliverable = Deliverable.new(deliverable_params)

    respond_to do |format|
      if @deliverable.save
        format.html { redirect_to @deliverable, notice: 'Deliverable was successfully created.' }
        format.json { render action: 'show', status: :created, location: @deliverable }
      else
        format.html { render action: 'new' }
        format.json { render json: @deliverable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliverables/1
  # PATCH/PUT /deliverables/1.json
  def update
    respond_to do |format|
      if @deliverable.update(deliverable_params)
        format.html { redirect_to @deliverable, notice: 'Deliverable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @deliverable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliverables/1
  # DELETE /deliverables/1.json
  def destroy
    @deliverable.destroy
    respond_to do |format|
      format.html { redirect_to deliverables_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deliverable
      @deliverable = Deliverable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deliverable_params
      params[:deliverable]
    end
end
