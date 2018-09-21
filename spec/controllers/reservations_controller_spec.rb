require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  describe 'GET #new' do
    before do
      sign_in(create(:user))
    end
    it 'assigns new Reservation to @reservation' do
      get :new
      expect(assigns(:reservation)).to be_a_new(Reservation)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before do
      sign_in(create(:user))
    end
    context 'with valid params' do
      it 'creates a new Reservation' do
        expect { post :create, params: { reservation: attributes_for(:reservation) } }
          .to change(Reservation, :count).by(1)
      end

      it 'redirects to reservation#doctor_choice' do
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
    before :each do
      @reservation = create(:reservation)
      sign_in(create(:user))
    end

    context 'valid attributes' do
      it 'locates the requested @reservation' do
        patch :update, params: { id: @reservation, reservation: attributes_for(:reservation) }
        expect(assigns(:reservation)).to eq(@reservation)
      end

      it "changes @contact's attribuites" do
        patch :update, params: {
          id: @reservation,
          reservation: attributes_for(:reservation,
                                      date_time: Time.new(2001, 10, 10),
                                      doctor_specialization: 'dentist')
        }
        @reservation.reload
        expect(@reservation.date_time).to eq(Time.new(2001, 10, 10))
        expect(@reservation.doctor_specialization).to eq('dentist')
      end

      it 'redirects to the updated reservation' do
        patch :update, params: { id: @reservation, reservation: attributes_for(:reservation) }
        expect(response).to redirect_to @reservation
      end
    end

    context 'with invalid attributes' do
      it "does not change the contact's attributes" do
        patch :update, params: {
          id: @reservation, reservation: attributes_for(:reservation,
                                                        doctor_specialization: nil)
        }
        @reservation.reload
        expect(@reservation.doctor_specialization).not_to eq(nil)
      end

      it 're-renders the :edit template' do
        patch :update, params: { id: @reservation,
                                 reservation: attributes_for(:invalid_reservation) }
        expect(response).to render_template :edit                        
      end
    end
  end
end
