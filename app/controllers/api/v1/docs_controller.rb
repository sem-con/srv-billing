module Api
    module V1
        class DocsController < ApiController
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            def encrypt
                email = params[:email].to_s
                pubkey_id = params["pubkey-id"].to_s
                data64 = params[:message].to_s
                data = Base64.decode64(data64)

                # import pubkey
                retVal = system("gpg --recv-keys " + pubkey_id)
                if !retVal
                    puts "Warning: failed to import public key " + pubkey_id.to_s
                    # render json: {"error": "failed to import public key"},
                    #        status: 500
                    # return
                end

                # check if pubkey matches provided email
                retVal = GPGME::Key.find(:public, email).first.primary_subkey.fingerprint
                if retVal != pubkey_id
                    render json: {"error": "email and public key ID don't match"},
                           status: 500
                    return
                end

                # encrypt data
                crypto = GPGME::Crypto.new()
                cipher = crypto.encrypt data, recipients: email, always_trust: true

                render json: {"cipher": Base64.strict_encode64(cipher.to_s)},
                       status: 200

            end

            def decrypt
                data = params[:cipher].to_s

                # decrypt
                crypto = GPGME::Crypto.new(password: ENV["PASSPHRASE"])
                message = crypto.decrypt Base64.decode64(data)

                render json: {"message": message.to_s},
                       status: 200

            end

            # $ curl localhost:4900/api/sign?data=aGVsbG8gd29ybGQ=
            # check:
            # signature from christoph.fabianek@gmail.com
            # iQJRBAABCgA7FiEE0y+HYXkDVCVp4Zu5ksjrI1RYnYcFAltOY18dHGNocmlzdG9waC5mYWJpYW5la0BnbWFpbC5jb20ACgkQksjrI1RYnYcmOBAApiRX0TvLonPCtKCj3Fia3IAwxfleyI8BqyGVCjQHWtuXriwm9HlXc4SMzgwXCkBXgVLRzUWZzW9GvzFoyNpuNlOtfkUzZiG+bLq50rPA5Cp3dPVkXJnIKOQsm6s271TySh6uk+BZEttZpN2v9OBqOipAxnwDRR7ZuJWubCRDef9aHe04SV9QvZ5CFiUqDf3nIlCX1AGj+Ebu19fGKuZIkUts9Vtvly6jiyPAYOSsAsHiVZLUYTOwPoQshxmaqB/QhBIMbPRVeDjr3vuvk+hoZzCXLS2CS1mVso9GTX4JwlmVmB+3sLnOMM7PsL737ZbWVexX6OmjQVueIUry/IWPGw2qMsLn8joQL5/5NzM/GZf7voUd2pjzFqiVEErswSCkWO0s4X7U11SbC+2bC3aaRbB9AAVO6MSAESpfwHjGmGpO6J56TWbJeTlcfAHLilYJlvY9nZ3rN/P9wqnae/Mbb0jESKlOAqPec21gTXLuot2T98VWbtxhb2kQwpsIuXKJOeaLABe5LvdhZFWbr5fcnu51412P+KYinixz94pPW3FW9f8Qa1A3Pb/funHHSRlm2h9eTPqSpBvYrP7AHmHnRbRKjT6wYj1PTTGRGdubtHixrem+P2boU7pYia4+ecw9FAjhpdQsxhMfAF5vy5e9Eg+z6Ka/KtDd9Qhmnxd+Krc=
            def sign
                begin
                    data64 = params[:data]
                    data = Base64.decode64(data64)
                    crypto = GPGME::Crypto.new(password: ENV["PASSPHRASE"].to_s)
                    signature = crypto.sign(data, signer: ENV["EMAIL"].to_s, mode: GPGME::SIG_MODE_DETACH)
                    render json: {"email": ENV["EMAIL"].to_s,
                                  "signature": Base64.strict_encode64(signature.to_s)}, 
                           status: 200

                rescue => error
                    render json: {"error": error.message},
                           status: 500
                end
            end

            def verify
                # info: https://www.rubydoc.info/github/ueno/ruby-gpgme/toplevel

                email = params[:email].to_s
                pubkey_id = params["pubkey-id"].to_s
                original = params[:original].to_s
                signature = params[:signature].to_s

                # import pubkey
                retVal = system("gpg --recv-keys " + pubkey_id)
                if !retVal
                    # try another keyserver
                    retVal = system("gpg --keyserver ha.pool.sks-keyservers.net --recv-keys " + pubkey_id)
                    if !retVal
                        render json: {"error": "failed to import public key"},
                               status: 500
                        return
                    end
                end

                # check if pubkey matches provided email
                retVal = GPGME::Key.find(:public, email).first.primary_subkey.fingerprint
                if retVal != pubkey_id
                    render json: {"error": "email and public key ID don't match"},
                           status: 500
                    return
                end

                # check validity
                valid_signature = true
                crypto = GPGME::Crypto.new()
                crypto.verify(Base64.decode64(signature), signed_text: original) { |s| valid_signature = false if !s.valid? }

                render json: {"valid": valid_signature},
                       status: 200
            end
        end
    end
end
