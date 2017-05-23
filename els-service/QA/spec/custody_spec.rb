require_relative '../lib/includes'

describe 'EELS services functionality for Custody entity' do
  it 'Starting the test suite' do
    @eels_auth.log_message("Start Test Suite: #{DateTime.now}")
  end

  context 'making a GET request for Custody' do
    before {
      @get_call = @eels_auth.get('Custody')
    }
    it 'results in a success with 200 as response code and "OK" as response message' do
      expect(@get_call[:code]).to eq 200
      expect(@get_call[:response]).to eq 'OK'
    end
  end

  context 'making a POST request for Custody' do
    before {
      @post_call = @eels_auth.post('Custody')
    }
    it 'results in successful response for request and a new resource is created' do
      expect(@post_call[:code]).to eq 201
      
      # Validating that the input body's property for the request is the same as the output property
       expect(JSON.parse(@post_call[:body])['Name']).to eq JSON.parse(@post_call[:inputObject])['Name']
    end
  end

 

  context 'making a PUT request for Custody' do
    before {
      @put_call = @eels_auth.put('Custody')
    }
    it 'results in a successful update of the entity per the update(put) body in the request' do
      expect(@put_call[:code]).to eq 204
      # Validating that the input body's Name for the request is the same as the output Name
      # expect(JSON.parse(@put_call[:body])['Name']).to eq JSON.parse(@put_call[:inputObject])['Name']
    end
  end
end
