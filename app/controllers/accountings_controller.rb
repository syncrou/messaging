class AccountingsController < ApplicationController
  before_action :set_accounting, only: [:show, :edit, :update, :destroy]

  # GET /accountings
  # GET /accountings.json
  def index
    @accountings = Accounting.all
  end

  # GET /accountings/1
  # GET /accountings/1.json
  def show
  end

  # GET /accountings/new
  def new
    @accounting = Accounting.new
  end

  # GET /accountings/1/edit
  def edit
  end

  # POST /accountings
  # POST /accountings.json
  def create
    @accounting = Accounting.new(accounting_params)

    respond_to do |format|
      if @accounting.save
        format.html { redirect_to @accounting, notice: 'Accounting was successfully created.' }
        format.json { render action: 'show', status: :created, location: @accounting }
      else
        format.html { render action: 'new' }
        format.json { render json: @accounting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accountings/1
  # PATCH/PUT /accountings/1.json
  def update
    respond_to do |format|
      if @accounting.update(accounting_params)
        format.html { redirect_to @accounting, notice: 'Accounting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @accounting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accountings/1
  # DELETE /accountings/1.json
  def destroy
    @accounting.destroy
    respond_to do |format|
      format.html { redirect_to accountings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting
      @accounting = Accounting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accounting_params
      params.require(:accounting).permit(:customer_id, :invoiced, :paid)
    end
end
