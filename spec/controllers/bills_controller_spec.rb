require 'rails_helper'

RSpec.describe BillsController, type: :controller do
  before do
    allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
  end

  describe 'GET #show' do
    before do
      @bill = create(:bill)
      sign_in(@bill.user)
      get :show, params: { id: @bill }
    end

    it 'assigns the requested bill to @bill' do
      expect(assigns(:bill)).to eq(@bill)
    end

    it 'renders to :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    before do
      @user = create(:user_with_many_bills)
      sign_in(@user)
      get :index
    end

    it 'assigns the requested bills to @user.bills' do
      expect(assigns(:bills)).to eq(@user.bills)
    end

    it 'renders the :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'PATCH #pay_bill' do
    before do
      @user = create(:user_with_many_bills, paid: false)
      sign_in(@user)
      patch :pay_bill, params: { bill_id: @user.bills.first }
    end

    it 'returns bill with changed paid_status for true' do
      expect(@user.bills.first.paid).to eq(true)
    end

    it 'redirects to bill#show' do
      expect(response).to redirect_to(bill_path(@user.bills.first))
    end
  end
end
