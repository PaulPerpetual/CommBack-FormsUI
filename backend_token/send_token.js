const web3 = require('web3');
const fs = require('fs');
const express = require('express');
const Tx = require('ethereumjs-tx');
const PublicGoogleSheetsParser = require('public-google-sheets-parser')

const app = express();
const spreadsheetId = '1PCXn3xrkgtivNgtkO-pCK65ctD0LsKPTX_iKFL2CqmA'

// // 1. You can pass spreadsheetId when instantiating the parser:
// const parser = new PublicGoogleSheetsParser(spreadsheetId)
// parser.parse().then((items) => {
//   // items should be [{"a":1,"b":2,"c":3},{"a":4,"b":5,"c":6},{"a":7,"b":8,"c":9}]
// })

//Infura HttpProvider Endpoint
web3js = new web3(new web3.providers.HttpProvider("https://sepolia.infura.io/v3/caa0044f5f594d758a13b887df92ca01"));

app.get('/sendtx',function(req,res){

        var myAddress = '0x83aC9E25C706Ca8B871bade94F019a2E03797978';
        var privateKey = Buffer.from('a9daf0d66ee7df34c5b446cbf24934067c20308b5058a83c9bd5f1abd619df45', 'hex');
        var toAddress = '0x677c430a082Ae9A68A3060a29609851C344C8367';

        //contract abi is the array that you can get from the ethereum wallet or etherscan
        var contractABI = JSON.parse(fs.readFileSync('../reward_token/artifacts/contracts/Token.sol/Token.json', 'utf8'));
        var contractAddress ="0xB013A5567a138Aa62A288E0Da45A3C730c8701f6";
        //creating contract object
        var contract = new web3js.eth.Contract(contractABI,contractAddress);

        var count;
        // get transaction count, later will used as nonce
        web3js.eth.getTransactionCount(myAddress).then(function(v){
            console.log("Count: "+v);
            count = v;
            var amount = web3js.utils.toHex(1e16);
            //creating raw tranaction
            var rawTransaction = {"from":myAddress, "gasPrice":web3js.utils.toHex(20* 1e9),"gasLimit":web3js.utils.toHex(210000),"to":contractAddress,"value":"0x0","data":contract.methods.transfer(toAddress, amount).encodeABI(),"nonce":web3js.utils.toHex(count)}
            console.log(rawTransaction);
            //creating tranaction via ethereumjs-tx
            var transaction = new Tx(rawTransaction);
            //signing transaction with private key
            transaction.sign(privateKey);
            //sending transacton via web3js module
            web3js.eth.sendSignedTransaction('0x'+transaction.serialize().toString('hex'))
            .on('transactionHash',console.log);
                
            contract.methods.balanceOf(myAddress).call()
            .then(function(balance){console.log(balance)});
        })
    });
app.listen(3000, () => console.log('Local Feedback app listening on port 3000!'))