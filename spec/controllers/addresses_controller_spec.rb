require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  describe 'GET #new' do
    before(:each) do
      sign_in(create(:user))
      get :new
    end

    it 'assigns new Address to @address' do
      expect(assigns(:address)).to be_a_new(Address)
    end

    it 'renders the :new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #show' do
    before do
      sign_in(create(:user))
      @address = create(:address)
      get :show, params: { id: @address }
    end

    it 'assigns the requested address to @address' do
      expect(assigns(:address)).to eq(@address)
    end

    it 'renders the :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before do
      sign_in(create(:user))
    end

    context 'with valid params' do
      it 'creates a new Address' do
        expect { post :create, params: { address: attributes_for(:address) } }
          .to change(Address, :count).by(1)
      end

      it 'redirects to address#show' do
        post :create, params: { address: attributes_for(:address) }
        expect(response).to redirect_to address_path(assigns[:address])
      end
    end

    context 'with invalid params' do
      it 'does not save new address to db' do
        expect { post :create, params: { address: attributes_for(:invalid_address) } }
          .not_to change(Address, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { address: attributes_for(:invalid_address) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before(:each) do
      @address = create(:address)
      sign_in(create(:user))
    end

    context 'valid attributes' do
      before do
        patch :update, params: {
          id: @address,
          address: attributes_for(:address, city: 'Moskwa', postal_code: '10-100')
        }
        @address.reload
      end
      it 'locates the requested @address' do
        expect(assigns(:address)).to eq(@address)
      end

      it 'changes @address attribuites' do
        expect(@address.city).to eq('Moskwa')
        expect(@address.postal_code).to eq('10-100')
      end

      it 'redirects to the updated address' do
        expect(response).to redirect_to @address
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: {
          id: @address, address: attributes_for(:invalid_address)
        }
        @address.reload
      end

      it 'does not change the address attributes' do
        expect(@address.city).not_to eq(nil)
      end

      it 're-renders the :edit template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'Delete #destroy' do
    before(:each) do
      sign_in(create(:user))
      @address = create(:address)
    end

    it 'deletes the address' do
      expect { delete :destroy, params: { id: @address } }.to change(Address, :count).by(-1)
    end

    it 'redirects to root' do
      delete :destroy, params: { id: @address }
      expect(response).to redirect_to root_path
    end
  end
end

