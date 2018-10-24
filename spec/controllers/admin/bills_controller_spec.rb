require 'rails_helper'

RSpec.describe Admin::BillsController, type: :controller do
  before do
    allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
    sign_in(create(:user, :admin))
  end

  describe 'GET #index' do
    before { allow_any_instance_of(Bill).to receive(:bill_items_empty) { true } }
    let!(:bills) { create_list(:bill, 3, paid: true) }

    context 'without params' do
      it 'assigns requested bills to @bills and renders the :index template' do
        get :index
        expect(assigns(:bills)).to eq(bills)
        expect(response).to render_template :index
      end
    end

    context 'with params[:payment_status]' do
      let!(:unpaid_bills) { create_list(:bill, 3, :unpaid) }

      it "assigns all not paid bills to @bills if params[:payment_status] = 'false'
          and renders :index template" do
        get :index, params: { payment_status: false }
        expect(assigns(:bills)).to eq(unpaid_bills)
        expect(response).to render_template :index
      end

      it "assigns paid bills to @bills if params[:payment_status] = 'true'
          and renders :index template" do
        get :index, params: { payment_status: true }
        expect(assigns(:bills)).to eq(bills)
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    let(:reservation) { create(:reservation_with_chosen_doctor) }

    it 'assigns new Bill to @bill, build bill_items and renders the :new template' do
      get :new, params: { reservation_id: reservation }
      expect(assigns(:bill)).to be_a_new(Bill)
      expect(assigns(:bill).bill_items).to all(be_a_new(BillItem))
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:reservation) { create(:reservation_with_chosen_doctor) }

    context 'with valid params' do
      let(:valid_params) do
        { bill: { bill_items_attributes: { '0': attributes_for(:bill_item),
                                           '1': attributes_for(:bill_item) } },
          reservation_id: reservation }
      end

      it 'creates a new Bill and 2 nested BillItem, assigns patient and reservation to @bill' do
        expect { post :create, params: valid_params }
          .to change(Bill, :count).by(1).and change(BillItem, :count).by(2)
        expect(assigns(:bill).reservation).to eq(reservation)
        expect(assigns(:bill).user).to eq(reservation.patient)
      end

      it 'redirects to the created bill' do
        post :create, params: valid_params
        expect(response).to redirect_to bill_path(assigns(:bill))
      end
    end

    context 'with invalid params' do
      it 'does not save new Bill and BIllItem to db and re-renders :new template' do
        # params with empty bill items
        invalid_params = { bill: { bill_items_attributes: { '0': '' } },
                           reservation_id: reservation }
        expect { post :create, params: invalid_params }
          .to not_change(Bill, :count).and not_change(BillItem, :count)
        expect(response).to render_template :new
      end
    end
  end
end
