class CarsController < ApplicationController
  
  def index
    @cars = current_person.try(:cars)
  end

  def show
    @car = current_person.cars.find(params[:id])
  end

  def new 
    @car = current_person.cars.new
  end

  def create 
    @car = Car.new(car_params)
    @car.owner = current_person
    if @car.save
      redirect_to cars_path, notice: "Car created successfully."
    else
      render('new')
    end  
  end

  def edit
    @car = current_person.cars.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])
    if @car.update_attributes(car_params)
      redirect_to @car, notice: "Car updated successfully."
    else
      render('edit')
    end
  end

  def destroy
    current_person.cars.find(params[:id]).destroy
    redirect_to cars_path, notice: "Car deleted successfully."
  end

  private

    def car_params
      params.require(:car).permit(:registration_number, :model, :image, :remove_image)
    end

end
