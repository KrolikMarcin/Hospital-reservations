class AddressesController < ApplicationController
  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      redirect to addresses_path
    else
      render :new
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :house_number,
                                    :postal_code, :apartment_number)
  end
end