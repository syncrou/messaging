class SmsController < ApplicationController
  load_and_authorize_resource
  def new
    @customer = Customer.find(params[:customer])
    @sms = Sms.new(:customer_id => params[:customer])
  end

  def show
    @sms = Sms.find(params[:id])
    render :text => @sms.inspect
  end

  def create
    @sms = Sms.new(sms_params)

    respond_to do |format|
      if @sms.save
        format.html { redirect_to @sms, notice: 'Sms was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sms }
      else
        format.html { render action: 'new' }
        format.json { render json: @sms.errors, status: :unprocessable_entity }
      end
    end
  end


  private


    def sms_params
      params.require(:sms).permit(:customer_id, :name, :to_deliver, :repeat, :body)
    end

end
