require_relative '../lib/includes'

 describe 'EELS services functionality for Container entity' do
  context 'making a GET request for Container' do
    before {
      @get_call = @eels_auth.get('Container')
    }
    it 'results in a success with 200 as response code and "OK" as response message' do
      expect(@get_call[:code]).to eq 200
      expect(@get_call[:response]).to eq 'OK'
    end
  end

  context 'making a PUT request for Container' do
    before { 
      @put_call = @eels_auth.put('Container')
    }
    it 'results in a successful update of the entity per the update(put) body in the request' do
      expect(@put_call[:code]).to eq 204
      
    end
  end
 end
