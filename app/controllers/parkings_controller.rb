class ParkingsController < ApplicationController
  skip_before_action :authenticate_account!

  def index
    @parkings = Parking.search(params).paginate(:page => params[:page], :per_page => Parking.per_page)
  end

  def show
    @parking = Parking.find(params[:id])
  end

  def new 
    @parking = Parking.new
    @parking.build_address
  end

  def create 
    @parking = Parking.new(parking_params)
    @parking.owner = current_person if current_person
    if @parking.save
      redirect_to parkings_path, notice: t('parking_created_success')
    else
      render('new')
    end  
  end

  def edit
    @parking = Parking.find(params[:id])
  end

  def update
    @parking = Parking.find(params[:id])
    if @parking.update_attributes(parking_params)
      redirect_to @parking, notice: t('parking_updated_success')
    else
      render('edit')
    end
  end

  def destroy
    Parking.find(params[:id]).destroy
    redirect_to parkings_path, notice: t('parking_deleted_success')
  end

  private

    def parking_params
      params.require(:parking).permit(:kind, :hour_price, :day_price, :places, 
        address_attributes: [:city, :street, :zip_code] )
    end

end

