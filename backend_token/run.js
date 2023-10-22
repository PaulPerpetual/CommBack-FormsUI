// import { contractABI } from "../reward_token/artifacts/contracts/Token.sol/Token.json"

require("dotenv").config();
const fs = require('fs');
const { ethers } = require("ethers");

// Configuring the connection to an Ethereum node
const network = process.env.ETHEREUM_NETWORK;

 // Define the ERC-20 token contract
const provider = new ethers.providers.InfuraProvider(
    network,
    process.env.INFURA_API_KEY
  );
 const tokenContract = "0xB013A5567a138Aa62A288E0Da45A3C730c8701f6";



    async function send_sepolia_ether() {
      
      // Creating a signing account from a private key
      const signer = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);

      // Creating and sending the transaction object
      const tx = await signer.sendTransaction({
        to: process.env.RECEIVER_ADDRESS,
        //value: ethers.utils.parseEther('30'),
        // nonce: window.ethersProvider.getTransactionCount(send_account, "latest"),
        //gasLimit: ethers.utils.hexlify(gas_limit), // 100000
        //gasPrice: gas_price,
        value: ethers.utils.parseUnits('0.05', 18),
      });
      console.log("Mining transaction...");
      console.log(`https://${network}.etherscan.io/tx/${tx.hash}`);
      // Waiting for the transaction to be mined
      const receipt = await tx.wait();
      // The transaction is now on chain!
      console.log(`Mined in block ${receipt.blockNumber}`);
    }

    
    //send_sepolia_ether();

    async function send_token() {

        var contractABI = JSON.parse(fs.readFileSync('../reward_token/artifacts/contracts/Token.sol/Token.json', 'utf8'));
        const contract = new ethers.Contract(tokenContract, contractABI, provider);
        console.log(contract);


        //Define the data parameter
        //const data = contract.interface.encodeFunctionData("transfer", [process.env.RECEIVER_ADDRESS, 30] )
        const data = await contract.populateTransaction.transfer(process.env.RECEIVER_ADDRESS, 30);

        // Creating a signing account from a private key
        const signer = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);
  

        const gas_limit = await provider.estimateGas({
            from: signer.address,
            to: process.env.tokenContract,
            value: ethers.BigNumber.from(0),
            data: data
           
          });

        // Creating and sending the transaction object
        const tx = await signer.sendTransaction({
          to: process.env.tokenContract,
          from: signer.address,
            //value: ethers.utils.parseUnits("0.5", "ether"),
            value: ethers.BigNumber.from(0),
            data: data,
            gasLimit: gas_limit, // 100000
          //value: ethers.utils.parseEther('30'),
          // nonce: window.ethersProvider.getTransactionCount(send_account, "latest"),
          
          //gasPrice: gas_price,
          
        });
        console.log("Mining transaction...");
        console.log(`https://${network}.etherscan.io/tx/${tx.hash}`);
        // Waiting for the transaction to be mined
        const receipt = await tx.wait();
        // The transaction is now on chain!
        console.log(`Mined in block ${receipt.blockNumber}`);
      }
  
    //   send_sepolia_ether();
    send_sepolia_ether();