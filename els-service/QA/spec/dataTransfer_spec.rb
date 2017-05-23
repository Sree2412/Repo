require_relative '../lib/includes'
  
describe 'EELS services functionality for DataTransfer entity' do
  context 'making a GET request for DataTransfer' do
    before {
      @get_call = @eels_auth.get('DataTransfer')
    }
    it 'results in a success with 200 as response code and "OK" as response message' do
      expect(@get_call[:code]).to eq 200
      expect(@get_call[:response]).to eq 'OK'
    end
  end

  context 'making a POST request for DataTransfer' do
    before {
      @post_call = @eels_auth.post('DataTransfer')
    }
    it 'results in successful response for request and a new resource is created' do
      expect(@post_call[:code]).to eq 201
      # Validating that the input body's property for the request is the same as the output property
      expect(JSON.parse(@post_call[:body])['Name']).to eq JSON.parse(@post_call[:inputObject])['Name']
    end
  end

  context 'making a PATCH request for DataTransfer' do
    before {
      @patch_call = @eels_auth.patch('DataTransfer')
    }
    it 'results in a successful update of the entity per the update(patch) body in the request' do
      expect(@patch_call[:code]).to eq 204
      # Validating that the input body's property for the request is the same as the output property
      # expect(JSON.parse(@patch_call[:body])['Name']).to eq JSON.parse(@patch_call[:inputObject])['Name']
    end
  end

  context 'making a PUT request for DataTransfer' do
    before {
      @put_call = @eels_auth.put('DataTransfer')
    }
    it 'results in a successful update of the entity per the update(put) body in the request' do
      expect(@put_call[:code]).to eq 204
      # Validating that the input body's Name for the request is the same as the output Name
      # expect(JSON.parse(@put_call[:body])['Name']).to eq JSON.parse(@put_call[:inputObject])['Name']
    end
  end

  # context 'making a DELETE request for DataTransfer' do
  #   before {
  #     @delete_call = @rest_call.delete('DataTransfer')
  #     @input_object = JSON.parse(@delete_call[:inputObject])
  #     @input_id = @input_object['Id'].to_s
  #     @input_name = @input_object['Name']
  #   }
  #   it 'results in an error since it is not allowed in the current context' do
  #     expect(@delete_call[:code]).to eq 501
  #     # Validating that the entity values set for delete did not get deleted
  #     expect(JSON.parse(@delete_call[:inputObject])['Name']).not_to include @input_name
  #   end
  # end
end
