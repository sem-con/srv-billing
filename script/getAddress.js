const args = process.argv;
const ethUtil = require('ethereumjs-util');
const HDKey = require('hdkey');

const seed = args[2];
const path = args[3];

const root = HDKey.fromMasterSeed(Buffer.from(seed, 'hex'));
const addrNode = root.derive(path);
const pubKey = ethUtil.privateToPublic(addrNode._privateKey);
const addr = ethUtil.publicToAddress(pubKey).toString('hex');
console.log(ethUtil.toChecksumAddress(addr));