require 'rails_helper'

RSpec.describe Admin::ReservationsController, type: :controller do
  before { allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true } }
  before { sign_in(create(:user, :admin)) }

  describe 'GET #index' do
    let(:reservations) do
      create_list(:reservation_with_chosen_doctor, 5, date_time: Time.now + 8.days)
    end

    context 'without params' do
      it 'assigns the requested reservations to @reservations and renders the :index template' do
        get :index
        expect(assigns(:reservations)).to eq(reservations)
        expect(response).to render_template :index
      end
    end

    context 'with params[:format]' do
      let(:todays_reservations) do
        create_list(:reservation_with_chosen_doctor, 3, date_time: Time.now + 1.hour)
      end

      it "returns all today's reservations if params[:format] = 'today_all_reservations' and
          renders :index template" do
        get :index, params: { format: 'today_all_reservations' }
        expect(assigns(:reservations)).to eq(todays_reservations)
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    let(:reservation) { create(:reservation_with_chosen_doctor) }

    it 'assigns the requested reservation to @reservation and renders the :show template' do
      get :show, params: { id: reservation }
      expect(assigns(:reservation)).to eq(reservation)
      expect(response).to render_template :show
    end
  end

  describe 'Delete #destroy' do
    let!(:reservation) { create(:reservation_with_chosen_doctor) }

    it 'deletes the @reservation and redirects to admin/reservations#index' do
      expect { delete :destroy, params: { id: reservation } }.to change(Reservation, :count).by(-1)
      expect(response).to redirect_to admin_reservations_path
    end
  end
end
