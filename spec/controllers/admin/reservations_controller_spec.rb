require 'rails_helper'

RSpec.describe Admin::ReservationsController, type: :controller do
  before { allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true } }
  before { sign_in(create(:user, :admin)) }

  describe 'GET #index' do
    let(:reservations) do
      create_list(:reservation_with_chosen_doctor, 5, :random_date)
    end

    context 'without params' do
      it 'assigns the requested reservations to @reservations and
          renders the :month_calendar template' do
        get :index
        expect(assigns(:reservations)).to eq(reservations)
        expect(response).to render_template :month_calendar
      end
    end

    context 'with params[:date]' do
      it "assigns requested reservations from chosen day if params[:date] and
          renders :index template" do
        get :index, params: { date: reservations.first.date_time }
        expect(assigns(:doctors)).to eq([reservations.first.doctor])
        expect(response).to render_template :index_with_chosen_date
      end
    end
  end
end
