class PlaceRentsController < ApplicationController
  
  def index
    @place_rents = PlaceRent.all
  end

  def show
    @place_rent = PlaceRent.find_by!(identifier: params[:id])
  end

  def new 
    @place_rent = PlaceRent.new
    @parking =  Parking.find(params[:parking_id])
  end

  def create 
    @place_rent = PlaceRent.new(place_rent_params)
    @place_rent.parking = Parking.find(params[:parking_id])
    
    @place_rent.start_date = parse_date params[:start_date]
    @place_rent.end_date = parse_date params[:end_date]

    if @place_rent.save
      redirect_to @place_rent, notice: "Place rent created successfully."
    else
      render('new')
    end  
  end

  private

    def place_rent_params
      params.require(:place_rent).permit(:start_date, :end_date, :car_id)
    end

    def parse_date main_param
      DateTime.civil(main_param[:year].to_i, main_param[:month].to_i, main_param[:day].to_i, main_param[:hour].to_i, main_param[:minute].to_i)
    end

end

