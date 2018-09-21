class AddressesController < ApplicationController
  before_action :authenticate_user!

  def show
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      redirect_to address_path(@address)
    else
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to address_path(@address)
    else
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to root_path
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :house_number,
                                    :postal_code, :apartment_number)
  end
end