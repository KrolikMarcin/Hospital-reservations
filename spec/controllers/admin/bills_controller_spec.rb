require 'rails_helper'

RSpec.describe Admin::BillsController, type: :controller do
  before do
    allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
    sign_in(create(:user, :admin))
  end
  describe 'GET #index' do
    before do
      allow_any_instance_of(Bill).to receive(:bill_items_empty) { true }
      @bills = create_list(:bill, 3, paid: true)
    end

    context 'without params' do
      it 'assigns requested bills to @bills and renders the :index template' do
        get :index
        expect(assigns(:bills)).to eq(@bills)
        expect(response).to render_template :index
      end
    end

    context 'with params[:format]' do
      it "assigns all not paid bills to @bills if params[:format] = 'not_paid'
          and renders :index template" do
        get :index, params: { format: 'not_paid' }
        not_paid_bills = create_list(:bill, 3, :not_paid)
        expect(assigns(:bills)).to eq(not_paid_bills)
        expect(response).to render_template :index
      end

      it "assigns all paid bills to @bills if params[:format] = 'paid'
          and renders :index template" do
        get :index, params: { format: 'paid' }
        create_list(:bill, 3, :not_paid)
        expect(assigns(:bills)).to eq(@bills)
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested bill to @bill and render :index template' do
      allow_any_instance_of(Bill).to receive(:bill_items_empty) { true }
      bill = create(:bill)
      get :show, params: { id: bill }
      expect(assigns(:bill)).to eq(bill)
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns new Bill to @bill, build bill_items and renders the :new template' do
      reservation = create(:reservation_with_chosen_doctor)
      get :new, params: { reservation_id: reservation }
      expect(assigns(:bill)).to be_a_new(Bill)
      expect(assigns(:bill).bill_items).to all(be_a_new(BillItem))
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before do
      @reservation = create(:reservation_with_chosen_doctor)
    end
    context 'with valid params' do
      before do
        bill_item = attributes_for(:bill_item)
        @valid_params = { bill: { bill_items_attributes: { '0': bill_item, '1': bill_item } },
                          reservation_id: @reservation }
      end
      it 'creates a new Bill and 2 nested BillItem, assigns patient and reservation to @bill' do
        expect { post :create, params: @valid_params }
          .to change(Bill, :count).by(1).and change(BillItem, :count).by(2)
        expect(assigns(:bill).reservation).to eq(@reservation)
        expect(assigns(:bill).user).to eq(@reservation.patient)
      end

      it 'redirects to the created bill' do
        post :create, params: @valid_params
        expect(response).to redirect_to admin_bill_path(assigns(:bill))
      end
    end

    context 'with invalid params' do
      it 'does not save new Bill and BIllItem to db and re-renders :new template' do
        # params with empty bill items
        invalid_params = { bill: { bill_items_attributes: { '0': '' } },
                           reservation_id: @reservation }
        expect { post :create, params: invalid_params }
          .to not_change(Bill, :count).and not_change(BillItem, :count)
        expect(response).to render_template :new
      end
    end
  end
end
