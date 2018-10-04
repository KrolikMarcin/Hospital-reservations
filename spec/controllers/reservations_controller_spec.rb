require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  describe 'GET #new' do
    before do
      sign_in(create(:user))
      @doctors = create_list(:user_doctor, 3, :random_specialization)
      get :new
    end

    it 'assigns new Reservation to @reservation, and specializations to @specializations' do
      expect(assigns(:reservation)).to be_a_new(Reservation)
      expect(assigns(:specializations)).to eq(@doctors.map(&:specialization).uniq)
    end

    it 'renders the :new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #show' do
    before do
      sign_in(create(:user_doctor))
      @reservation = create(:reservation)
      get :show, params: { id: @reservation }
    end

    it 'assigns the requested reservation to @reservation' do
      expect(assigns(:reservation)).to eq(@reservation)
    end

    it 'renders the :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before do
      @patient = create(:user)
      create(:user_doctor)
      sign_in(@patient)
    end

    context 'with valid params' do
      it 'creates a new Reservation, and assign patient to reservation' do
        expect { post :create, params: { reservation: attributes_for(:reservation) } }
          .to change(Reservation, :count).by(1)
        expect(assigns(:reservation).users).to eq([@patient])
      end

      it 'redirects to reservations#doctor_choice' do
        post :create, params: { reservation: attributes_for(:reservation) }
        expect(response).to redirect_to reservation_doctor_choice_path(assigns[:reservation])
      end
    end

    context 'with invalid params' do
      it 'does not save new reservation to db' do
        expect { post :create, params: { reservation: attributes_for(:invalid_reservation) } }
          .not_to change(Reservation, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { reservation: attributes_for(:invalid_reservation) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      @reservation = create(:reservation_with_chosen_doctor)
      sign_in(@reservation.patient)
    end

    context 'with valid attributes' do
      before do
        patch :update, params: {
          id: @reservation, reservation: { date_time: Time.new(2019, 10, 10),
                                           doctor_specialization: 'dentist' }
        }
        @reservation.reload
      end

      it 'locates the requested @reservation' do
        expect(assigns(:reservation)).to eq(@reservation)
      end

      it "changes @reservation's attribuites" do
        expect(@reservation.date_time).to eq(Time.new(2019, 10, 10))
        expect(@reservation.doctor_specialization).to eq('dentist')
      end

      it 'redirects to the updated reservation' do
        expect(response).to redirect_to @reservation
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: {
          id: @reservation, reservation: attributes_for(:invalid_reservation)
        }
        @reservation.reload
      end

      it "does not change the reservation's attributes" do
        expect(@reservation.doctor_specialization).not_to eq(nil)
      end

      it 're-renders the :edit template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'Delete #destroy' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      sign_in(create(:user))
      @reservation = create(:reservation)
    end

    it 'deletes the @reservation' do
      expect { delete :destroy, params: { id: @reservation } }.to change(Reservation, :count).by(-1)
    end

    it 'redirects to reservations#index' do
      delete :destroy, params: { id: @reservation }
      expect(response).to redirect_to reservations_path
    end
  end

  describe 'GET #doctor_choice' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      @reservation = create(:reservation)
      @doctors = create_list(:user_doctor, 3, specialization: @reservation.doctor_specialization)
      sign_in(@reservation.patient)
      get :doctor_choice, params: { reservation_id: @reservation.id }
    end

    it 'assigns reservation to @resevation and free doctors to @doctors' do
      expect(assigns(:reservation)).to eq(@reservation)
      expect(assigns(:doctors)).to eq(@doctors.map(&:collection))
    end

    it 'renders the :doctor_choice template' do
      expect(response).to render_template :doctor_choice
    end
  end

  describe 'PATCH #doctor_choice_save' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      @reservation = create(:reservation)
      sign_in(@reservation.patient)
      @doctor = create(:user_doctor, specialization: @reservation.doctor_specialization)
      patch :doctor_choice_save, params: {
        reservation_id: @reservation.id, reservation: { user_ids: @doctor.id }
      }
      @reservation.reload
    end

    it 'assigns the requested reservation and chosen doctor to @reservation' do
      expect(assigns(:reservation)).to eq(@reservation)
      expect(assigns(:reservation).users).to eq([@reservation.patient, @doctor])
    end

    it 'redicrects to reservations#index' do
      expect(response).to redirect_to reservations_path
    end
  end

  describe 'GET #change_status' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      @reservation = create(:reservation_with_chosen_doctor)
      sign_in(@reservation.employee)
      get :change_status, params: { reservation_id: @reservation.id }
    end

    it 'assigns reservation to @reservation, and build prescriptions' do
      expect(assigns(:reservation)).to eq(@reservation)
      expect(assigns(:reservation).prescriptions).to all(be_a_new(Prescription))
    end

    it 'renders the :change_status template' do
      expect(response).to render_template :change_status
    end
  end

  describe 'PATCH #change_status_save' do
    context 'with valid params' do
      before do
        allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
        @reservation = create(:reservation_with_chosen_doctor)
        sign_in(@reservation.employee)
        patch :change_status_save, params: {
          reservation_id: @reservation.id, reservation: {
            prescriptions_attributes: [attributes_for(:prescription), attributes_for(:prescription)]
          }
        }
      end

      it 'assigns precriptions to @reservation' do
        expect(assigns(:reservation)).to eq(@reservation)
        expect(assigns(:reservation).prescriptions).to eq(@reservation.prescriptions)
        expect(assigns(:reservation).prescriptions).not_to eq([])
      end

      it 'redirects to reservations#show' do
        expect(response).to redirect_to reservation_path(assigns(:reservation))
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
        @reservation = create(:reservation_with_chosen_doctor)
        sign_in(@reservation.employee)
        patch :change_status_save, params: {
          reservation_id: @reservation.id, reservation: {
            prescriptions_attributes: [attributes_for(:invalid_prescription)]
          }
        }
      end

      it 'did not create an empty recipe' do
        expect(assigns(:reservation).prescriptions).to eq([])
      end

      it 're-renders change_status template' do
        expect(response).to render_template :change_status
      end
    end
  end

  describe 'GET #index' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      @doctor = create(:doctor_with_many_reservations, reservations_count: 10)
      sign_in(@doctor)
    end

    context 'with params[:format]' do
      it "returns only today's reservations for a login doctor if
          params[:format] = :doctor_today_reservations" do
        get :index, params: { format: 'doctor_today_reservations' }
        expect(assigns(:reservations)).to eq(@doctor.reservations
                                                    .where(date_time: Time.now.all_day))
      end

      it "returns reservations from this week's for a login doctor if
          params[:format] = :doctor_week_reservations" do
        get :index, params: { format: 'doctor_week_reservations' }
        expect(assigns(:reservations)).to eq(@doctor.reservations
                                              .where(date_time: Time.now.all_week))
      end

      it "returns reservations from this month's for a login doctor if
          params[:format] = :doctor_month_reservations" do
        get :index, params: { format: 'doctor_month_reservations' }
        expect(assigns(:reservations)).to eq(@doctor.reservations
                                              .where(date_time: Time.now.all_month))
      end
    end

    context 'without params' do
      it 'returns all login user reservations' do
        get :index
        expect(assigns(:reservations)).to eq(@doctor.reservations.order(date_time: :desc))
      end
    end
  end
end
