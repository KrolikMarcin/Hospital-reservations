require 'rails_helper'

RSpec.describe Admin::ReservationsController, type: :controller do
  describe 'GET #index' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      sign_in(create(:user, :admin))
      @reservations = create_list(:reservation_with_chosen_doctor, 5, date_time: Time.now + 8.days)
    end

    context 'without params' do
      it 'assigns the requested reservations to @reservations' do
        get :index
        expect(assigns(:reservations)).to eq(@reservations)
      end

      it 'renders :index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'with params[:format]' do
      before do
        get :index, params: { format: 'today_all_reservations' }
        @todays_reservations = create_list(
          :reservation_with_chosen_doctor, 3, date_time: Time.now + 1.hour
        )
      end

      it "returns all today's reservations if params[:format] = 'today_all_reservations'" do
        expect(assigns(:reservations)).to eq(@todays_reservations)
      end

      it 'renders :index template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      sign_in(create(:user, :admin))
      @reservation = create(:reservation_with_chosen_doctor)
      get :show, params: { id: @reservation }
    end

    it 'assigns the requested reservation to @reservation' do
      expect(assigns(:reservation)).to eq(@reservation)
    end

    it 'renders the :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'Delete #destroy' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      sign_in(create(:user, :admin))
      @reservation = create(:reservation)
    end

    it 'deletes the @reservation' do
      expect { delete :destroy, params: { id: @reservation } }.to change(Reservation, :count).by(-1)
    end

    it 'redirects to admin/reservations#index' do
      delete :destroy, params: { id: @reservation }
      expect(response).to redirect_to admin_reservations_path
    end
  end

end
