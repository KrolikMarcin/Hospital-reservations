require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  describe 'GET #new' do
    it 'assigns new Address to @address and renders the :new template' do
      sign_in(create(:user))
      get :new
      expect(assigns(:address)).to be_a_new(Address)
    end
  end

  describe 'GET #show' do
    let(:address) { create(:address) }
    before { sign_in(create(:user)) }

    it 'assigns the requested address to @address and renders the :show template' do
      get :show, params: { id: address }
      expect(assigns(:address)).to eq(address)
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    before { sign_in(user) }

    context 'with valid params' do
      it 'creates a new Address and assigns user to this Address, redirects to address#show' do
        expect { post :create, params: { address: attributes_for(:address) } }
          .to change(Address, :count).by(1)
        expect(assigns(:address).user).to eq(user)
        expect(response).to redirect_to address_path(assigns[:address])
      end
    end

    context 'with invalid params' do
      it 'does not save new address to db and re-renders the :new template' do
        expect { post :create, params: { address: attributes_for(:invalid_address) } }
          .not_to change(Address, :count)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:address) { create(:address) }
    before { sign_in(create(:user)) }

    context 'valid attributes' do
      before do
        patch :update, params: {
          id: address,
          address: attributes_for(:address, city: 'Moskwa', postal_code: '10-100')
        }
        address.reload
      end

      it 'locates the requested @address' do
        expect(assigns(:address)).to eq(address)
      end

      it 'changes @address attribuites' do
        expect(address.city).to eq('Moskwa')
        expect(address.postal_code).to eq('10-100')
      end

      it 'redirects to the updated address' do
        expect(response).to redirect_to address
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: {
          id: address, address: attributes_for(:invalid_address)
        }
        address.reload
      end

      it 'does not change the address attributes, and re-renders the :edit template' do
        expect(address.city).not_to eq(nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'Delete #destroy' do
    let!(:address) { create(:address) }
    before { sign_in(create(:user)) }

    it 'deletes the address and redirects to root' do
      expect { delete :destroy, params: { id: address } }.to change(Address, :count).by(-1)
      expect(response).to redirect_to root_path
    end
  end
end
