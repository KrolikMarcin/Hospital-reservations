require 'rails_helper'

RSpec.describe BillsController, type: :controller do
  before do
    allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
    allow_any_instance_of(Bill).to receive(:bill_items_empty) { true }
  end

  describe 'GET #show' do
    let(:bill) { create(:bill) }
    before { sign_in(bill.user) }

    it 'assigns the requested bill to @bill and renders to :show template' do
      get :show, params: { id: bill }
      expect(assigns(:bill)).to eq(bill)
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    let(:user) { create(:user_with_many_bills) }
    before { sign_in(user) }

    it 'assigns the requested bills to user.bills and renders the :index template' do
      get :index
      expect(assigns(:bills)).to eq(user.bills)
      expect(response).to render_template :index
    end
  end

  describe 'PATCH #pay_bill' do
    let(:bill) { create(:bill, paid: false) }
    before { sign_in(bill.user) }

    it 'returns bill with changed paid_status for true and redirects to bill#show' do
      patch :pay_bill, params: { bill_id: bill }
      expect(assigns(:bill).paid).to eq(true)
      expect(response).to redirect_to(bill_path(bill))
    end
  end
end
