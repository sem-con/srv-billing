require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'Semantic Container Billing Service API',
        version: 'v1',
        "description": "The billing service for Semantic Containers provides basic functions for selling data.\n \n Further information:\n - detailed description on configuring the service on start up at https://github.com/sem-con/srv-billing\n - learn more about Semantic Containers at https://www.ownyourdata.eu/semcon\n - view other [OwnYourData Service API's](https://api-docs.ownyourdata.eu)",
        "contact": {
          "email": "office@ownyourdata.eu"
        },
        "license": {
          "name": "MIT License",
          "url": "https://opensource.org/licenses/MIT"
        }
      },
      paths: {},
      securityDefinitions: {
        Bearer: {
          description: "Authorization token",
          type: :apiKey,
          name: 'Authorization',
          in: :header
        }
      }
    }
  }
end
