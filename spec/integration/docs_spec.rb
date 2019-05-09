# spec/integration/docs_spec.rb
# rake rswag:specs:swaggerize

ENV["PASSPHRASE"] = File.read(".env_rspec")

require 'swagger_helper'

describe 'Document API' do
	path '/api/encrypt' do
		post 'encrypt string' do
			tags 'Cryptography'
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
				} }
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

	path '/api/decrypt' do
		post 'decrypt string' do
			tags 'Cryptography'
			consumes 'application/json'
			parameter name: :input, in: :body, schema: {
				type: :object,
				properties: {
					cipher: { type: :string }
				},
				required: [ 'cipher' ]
			}
			response '200', 'success' do
				let(:input) { {
					"cipher": "hQIMA2VoyGufPHbNARAArcD9pkDrm6oCIkJsusF+FtgZI1O4FwwsJe18y/5jXM1tXrl5fiNIDoe4kMgZNIwC0Q0mtiWlYhfQZUqAr1yVRVJmiCfz7p6CLaP8gjKYKkGpz5TcumPVcKVAGsmVwhb8ZHAaJW8GzGu+Qhn1keXJ06LJqhVIfo9F27QubDh5I2QtuCjhUGgMUDamSHW2DOf01jFWcVSkzh26EYX/5lytXFxPwwsgRvAA+aMl0ef02ybJyOtGrfZDglLuC6Vcli2Gc9jO/XznI1Dil8aAxflV8w8GcDC+J9dFlkftreV9RtX8Y/cikGFe25zm3Iliqd8Ol4FBSixC2JHiWmT35NTPE28aLo0bSeclLK7MYw1WUGOuiXYoR8Wc0TkTwuO4atYFeX9DWK57T5nww4lZASFintcuH208U8+a1dKZi4zkBHWkpSdt0b+mu1b84NmOA7PqCy4N5+7YmiN2t1c2XT+wLO6px4OHOb6zLljtGtujqpJHXIODDptfFa3e9Ht8MfSLXeIwHLEm8yziJy2LwiXq8EvpidX87JmjiVo0d6MHnvWigJJQ8nYKUnMo2L0K8QqT1d8uu0Rk3+LoKDD+lSX/klwBxmTK0wKcJeytsBZE/S1/fcmDU0grobd5xXPDDAPq5nr/qUUfJJDrjk8iKmZ/+iQJYUCWb+AxZKPz+SwriRLSRgEECO3zk+EpZr2jsvaX28mYnVJYN2h1CupHZd7Jpt0W7R4w83nSez2hMaBE5IzE3Adrt/A9MG3LWY/XB4nid7xsTEVaPuk="
				} }
				schema type: :object,
					properties: {
						message: { type: :string }
					},
				required: [ 'message' ]
				run_test! do
				end
			end
		end
	end

	path '/api/sign' do
		post 'sign string' do
			tags 'Cryptography'
			consumes 'application/json'
			parameter name: :input, in: :body, schema: {
				type: :object,
				properties: {
					data: { type: :string }
				},
				required: [ 'data' ]
			}
			response '200', 'success' do
				let(:input) { {
					"data": "aGVsbG8gd29ybGQ="
				} }
				schema type: :object,
					properties: {
						email: { type: :string },
						signature: { type: :string }
					},
				required: [ 'signature' ]
				run_test! do
				end
			end
		end
	end

	path '/api/verify' do
		post 'verify signature' do 
			tags 'Cryptography'
			consumes 'application/json'
			parameter name: :input, in: :body, schema: {
				type: :object,
				properties: {
					email: { type: :string },
					'pubkey-id': { type: :string },
					original: { type: :string },
					signature: { type: :string }
				},
				required: [ 'cipher' ]
			}
			response '200', 'success' do
				let(:input) { {
					"email": "christoph.fabianek@gmail.com",
					"pubkey-id": "D32F87617903542569E19BB992C8EB2354589D87",
					"original": "hello world",
					"signature": "iQIzBAABCAAdFiEE0y+HYXkDVCVp4Zu5ksjrI1RYnYcFAlzUsw4ACgkQksjrI1RYnYfsHxAAq0SRQCz82PRvubmep8TZJVDd7FMMlOKyr+3y5rKpbiIkFBnxuS+1slZFIvTHdE0YocrQvfoxW6hdu2zujvn3/XrBhiodqWaLsth0lzoY7E0ae/x/A+fgprqv3FO4DSingi2bVnksMCbYLvUQsDYrgNhPRYnBLKH8IVfwd57sjL5fT7XsDge5CSaCEMbJHDKsbO7bU3Yzj7CRDWYIwf9P+CD3LLKphwBT1jQ0xcY8sVC3GhbvaBbFgHVj/ATkcnqhHeYWdHO515+NlxzpLNklaprkxyg+qoX4LNg1DO68zFTob7EKZWpriNhrMgdGIqPj/EIKFAZhGRwVqbVqlXT1y6V6G9hbXnYibEEhFdm3VBjjppLN6LXqK1YvIXMZN/K/mWdmcCQs5OIWPtDk2xOKy7UVPjvHWupF66JE17qPzZcpmszzWm8miEg4rqb8uf6kzKY2JkbQfF+5oXhGBn2/0BvLkGQnL9380JaQpKMxfpsRakJnES0JcR97uug/8p1x16f/nKw+ZvAaupwU6qT3jbdl5z9LkNXlWe4tzTSowHssfZmUsLK8TC4ETR+eMC31U6WN8/kK7SqvAmgjf64d/oHk5YPj+D5tnmqJyVce1pfMTzCbi1GoB+m5/7b5Xqw0EdKjrC9wOfbDbKj3dj2VTS8NYDsuEuCQPL/iuhSF3TM="
				} }
				schema type: :object,
					properties: {
						valid: { type: :boolean }
					},
				required: [ 'valid' ]
				run_test! do
				end
			end
		end
	end
end


describe 'Payment API' do
	path '/api/payment_info' do
		get 'list general payment information' do
			tags 'Payment'
			produces 'application/json'
			response '200', 'success' do
				schema type: :object,
					properties: {
						address: { type: :string },
						email: { type: :string },
						'pubkey-id': { type: :string }
					},
				required: [ 'address', 'email', 'pubkey-id' ]
				run_test! do
				end
			end

		end
	end

	path '/api/price' do 
		post 'calculate price for data' do 
			tags 'Payment'
			consumes 'application/json'
			parameter name: :input, in: :body, schema: {
				type: :object,
				properties: {
					request: { type: :string },
					'usage-policy': { type: :string },
					method: { type: :string }
				},
				required: [ 'request', 'usage-policy', 'method' ]
			}
			response '200', 'success' do
				let(:input) { {
					"request": "key=value",
					"usage-policy": "",
					"method": "ether"
				} }
				schema type: :object,
					properties: {
						price: { type: :string }
					},
				required: [ 'price' ]
				run_test! do
				end
			end
		end
	end
end

describe 'Blockchain API' do
	path '/api/transaction?tx={transaction_hash}' do
		get 'access transaction information' do 
			tags 'Blockchain'
			produces 'application/json'
			parameter name: :transaction_hash, in: :path, type: :string
			response '200', 'success' do
				let(:transaction_hash) { '0x06bf30b730ead19766d55c0cd3fe6a37a932861eb7fa6d0eaa9c430b9866c876' }
				run_test! do
				end
			end
		end
	end
end