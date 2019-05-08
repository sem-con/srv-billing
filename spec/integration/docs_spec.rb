# spec/integration/base_spec.rb
# rake rswag:specs:swaggerize

ENV["KEY_FILE"] = "tmp/secret.key"

require 'swagger_helper'

describe 'Document API' do
	path '/api/encrypt' do
		post 'encrypt string' do
			tags 'String handling'
			consumes 'application/json'
			parameter name: :input, in: :body, schema: {
				type: :object,
				properties: {
					email: { type: :string },
					'pubkey-id': { type: :string },
					message: { type: :string }
				},
				required: [ 'email', 'pubkey-id', 'message' ]
			}
			response '200', 'success' do
				let(:input) { {
					"email": "christoph.fabianek@gmail.com",
					"pubkey-id": "D32F87617903542569E19BB992C8EB2354589D87",
					"message": "hello world"
				}}
				schema type: :object,
					properties: {
						cipher: { type: :string }
					},
				required: [ 'cipher' ]
				run_test! do
				end
			end
		end
	end
end