Rails.application.routes.draw do
	mount Rswag::Ui::Engine => '/api-docs'
	mount Rswag::Api::Engine => '/api-docs'
	namespace :api, defaults: { format: :json } do
		scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
			match 'decrypt', to: 'docs#decrypt', via: 'post'
			match 'encrypt', to: 'docs#encrypt', via: 'post'
			match 'sign',    to: 'docs#sign',    via: 'get'
			match 'sign',    to: 'docs#sign',    via: 'post'
			match 'verify',  to: 'docs#verify',  via: 'post'

			match 'payment_info',  to: 'payments#info',  via: 'get'
			match 'payment_terms', to: 'payments#terms', via: 'post'

			match 'transaction', to: 'blockchains#transaction', via: 'get'
		end
	end
end
