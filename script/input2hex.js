const args = process.argv;
const Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var str = web3.utils.toAscii(args[2]);
console.log(str);
