import { task } from "hardhat/config";
import { parseUnits } from "ethers/lib/utils";
//import { ethers } from "hardhat";
//import { hexConcat } from "@ethersproject/bytes";

task("setbridge", "Set bridge role in NFT", async (args, hre) => {
  const [addr1, addr2, ...addrs] = await hre.ethers.getSigners();

  const nft = await hre.ethers.getContractAt("NFT", process.env.NFT_ADDR as string);
  await nft.connect(addr1).setBridgeRole(process.env.BRIDGE_ADDR);

  console.log('setbridge task Done!'); 
});