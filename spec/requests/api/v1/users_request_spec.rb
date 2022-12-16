require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:params) do
    {
      user: {
        name: Faker::Name.name_with_middle,
        cpf: Faker::IDNumber.brazilian_citizen_number
      }
    }
  end

  let(:user) { create(:user) }
  describe 'GET /users' do
    before { get api_v1_users_path }
    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/:id' do
    context 'when user exists' do
      before { get api_v1_user_path(user.id) }
      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
      it 'NAME and CPF be_kind_of String' do
        response_body = JSON.parse(response.body)
        expect(response_body.fetch('name')).to be_kind_of(String)
        expect(response_body.fetch('cpf')).to be_kind_of(String)
      end
    end
    context 'when User does not exist' do
      it 'raises RecordNotFound when not found' do
        expect { get api_v1_user_path(0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST /users' do
    let(:created_user) { User.last }
    context 'when CPF and NAME is VALID' do
      let(:json) { JSON.parse(response.body, symbolize_names: true) }
      before { post api_v1_users_path, params: params }
      it 'returns http status 201' do
        expect(response).to have_http_status(201)
      end
      it 'creates an user' do
        expect(created_user.name).to eq(json.dig(:name))
      end
    end
    context 'when CPF or NAME is INVALID' do
      it 'returns 422 with invalid name' do
        post api_v1_users_path, params: { user: { name: 'INVALID', cpf: '064.427.806-43' } }
        expect(response).to have_http_status(422)
      end
      it 'returns 422 with invalid cpf' do
        post api_v1_users_path, params: { user: { name: 'VALID Name OK', cpf: 'INVALID' } }
        expect(response).to have_http_status(422)
      end
      it 'do not create an user' do
        expect { created_user.name }.to raise_error(NoMethodError)
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'when user exists' do
      it 'returns 200 with valid name' do
        put api_v1_user_path(user.id), params: { user: { name: '10 characters +' } }
        expect(response).to have_http_status(200)
      end
      it 'returns 200 with valid cpf' do
        put api_v1_user_path(user.id), params: { user: { cpf: Faker::IDNumber.brazilian_citizen_number } }
        expect(response).to have_http_status(200)
      end
      it 'returns 422 with invalid name' do
        put api_v1_user_path(user.id), params: { user: { name: 'short' } }
        expect(response).to have_http_status(422)
      end
      it 'returns 422 with invalid cpf' do
        put api_v1_user_path(user.id), params: { user: { cpf: 'INVALID' } }
        expect(response).to have_http_status(422)
      end
    end
    context 'when user does not exists' do
      it 'raises RecordNotFound when not found' do
        expect { put api_v1_user_path(User.find(0)), params: params }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe 'DELETE' do
    context 'when user exists' do
      it 'returns 200' do
        delete api_v1_user_path(user.id)
        expect(response).to have_http_status(204)
       end
    end
    context 'when user does not exist' do
      it 'raises RecordNotFound when not found' do
        expect { delete api_v1_user_path(User.find(0)) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end