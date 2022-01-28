import { task } from "hardhat/config";
import { parseUnits } from "ethers/lib/utils";
//import { ethers } from "hardhat";
//import { hexConcat } from "@ethersproject/bytes";

task("swap", "Swap token between chains")
.addParam("index", "NFT index")
.addParam("nonce", "just nonce")
.setAction(async (taskArgs, hre) => {
  const [addr1, addr2, ...addrs] = await hre.ethers.getSigners();

  const nft = await hre.ethers.getContractAt("NFT", process.env.NFT_ADDR as string);
  const bridge = await hre.ethers.getContractAt("Bridge", process.env.BRIDGE_ADDR as string);
  await bridge.connect(addr1).swap(taskArgs.index, 97, taskArgs.nonce);

  console.log('swap task Done!'); 
});