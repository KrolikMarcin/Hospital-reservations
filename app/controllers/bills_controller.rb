class BillsController < ApplicationController
  def new
    @bill = Bill.new
  end

  def create
    pry binding
  end
end