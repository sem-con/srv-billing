# srv-billing

# <img src="https://github.com/sem-con/sc-seismic/raw/master/app/assets/images/oyd_green.png" width="60"> Billing Service    
This [Semantic Container](https://www.ownyourdata.eu/semcon) Service provides functionality and information to allow selling access to data.     

Docker Image: https://hub.docker.com/r/semcon/srv-billing    
Swagger Documentation: https://api-docs.ownyourdata.eu/semcon-billing/    

## Usage    
To get a general introduction to the use of Semantic Containers please refer to the [SemCon Tutorial](https://github.com/sem-con/Tutorials).     

### Starting the Service    
The service requires a GPG key file and a number of environment variables as input. Provide the GPG key file in a directory that is made accessible through a volume and the following environment variables:

* for a fixed payment address provide the following information:    
    ```
    KEY_FILE=/key/secret.key
    EMAIL=mail@company.com
    PASSPHRASE=your passphrase here
    ETHER_ADDRESS=0123456789abcdef0123456789abcdef01234567
    ETHERSCAN_APIKEY=1234567890ABCDEFGHIJKLMNOPQRSTUVWX
    ```    

* to use a new address for every transaction provide the following information for a BIP-39 conform hierarchical deterministic wallet:    
    ```
    KEY_FILE=/key/secret.key
    EMAIL=mail@company.com
    PASSPHRASE=your passphrase here
    HDW_SEED=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
    HDW_PATH=m/44'/60'/0'
    ETHERSCAN_APIKEY=1234567890ABCDEFGHIJKLMNOPQRSTUVWX
    ```     

Notes for the environment variables:    
* _KEY_FILE_: according to the mounted volume on startup of the container and name of the GPG key file    
* _EMAIL_: email address associated with the GPG key    
* _PASSPHRASE_: passphrase for the GPG key    
* _ETHER_ADDRESS_: public address to be used when transferring a cryptocurrency    
* _HDW_SEED_: seed to create the root keys of a hierarchical deterministic wallet    
* _HDW_PATH_: path to the branch for generating addresses    
* _ETHERSCAN_APIKEY_: API key from [Etherscan.io](https://etherscan.io/apis) to perform payment validation services   

With the information from above the docker container can be started with the following command:    
(assuming the GPG key is in `$PWD/key/secret.key` and the environment variables are set in the file `.env`)
```
$ docker run -d --name srv-billing -v $PWD/key:/key --env-file .env semcon/srv-billing
```

### Accessing the Service    
Since the billing service holds sensitive information it is recommended to expose no ports and uses a private network between the Semantic Container and the Billing Service:    
```
$ docker run -p 4000:3000 -d --name demo -e AUTH=billing --link srv-billing semcon/sc-base /bin/init.sh "$(< init_billing.trig)"
```    

Please note that a Semantic Container expects to connect to the billing service via `http://srv-billing:3000` (as specified in `image-constraints.trig`). 

See the [Github sc-tawes repository](https://github.com/sem-con/sc-tawes) for an example on using the Billing Service.


## Improve this Semantic Container Service    

Please report any bugs or feature requests in the [GitHub Issue-Tracker](https://github.com/sem-con/srv-billing/issues) and follow the [Contributor Guidelines](https://github.com/twbs/ratchet/blob/master/CONTRIBUTING.md).

If you want to develop yourself, follow these steps:

1. Fork it!
2. Create a feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Send a pull request

&nbsp;    

## Lizenz

[MIT Lizenz 2019 - OwnYourData.eu](https://raw.githubusercontent.com/sem-con/srv-billing/master/LICENSE)

