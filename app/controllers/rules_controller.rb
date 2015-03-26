class RulesController < ApplicationController
load_and_authorize_resource
  before_action :set_rule, only: [:show, :edit, :update, :destroy]

  # GET /rules
  # GET /rules.json
  def index
    @rules = Rule.all
  end

  # GET /rules/1
  # GET /rules/1.json
  def show
  end

  # GET /rules/new
  def new
    @rule = Rule.new
  end

  # GET /rules/1/edit
  def edit
  end

  # POST /rules
  # POST /rules.json
  def create
    @rule = Rule.new(rule_params)
    @rule.rule.gsub!(/\r\n/,' ')

    respond_to do |format|
      if @rule.save
        format.html { redirect_to @rule, notice: 'Rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rules/1
  # PATCH/PUT /rules/1.json
  def update
    respond_to do |format|
      rule_params[:rule].gsub!(/\r\n/,' ')
      if @rule.update(rule_params)
        format.html { redirect_to @rule, notice: 'Rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.json
  def destroy
    @rule.destroy
    respond_to do |format|
      format.html { redirect_to rules_url }
      format.json { head :no_content }
    end
  end

  def deactivate
    rule = Rule.find(params[:id])
    rule.deactivate!
    redirect_to rules_path
  end

  def activate
    rule = Rule.find(params[:id])
    rule.activate!
    redirect_to rules_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rule
      @rule = Rule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rule_params
      params.require(:rule).permit(:rule, :rule_body, :deliver_at, :extra_var_1, :extra_var_2, :extra_var_3, :extra_var_4, :extra_var_5, :subject, :customer_id, :name, :rule_type)
    end
end
