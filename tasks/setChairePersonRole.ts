import { task } from "hardhat/config";
import { parseUnits } from "ethers/lib/utils";
//import { ethers } from "hardhat";
//import { hexConcat } from "@ethersproject/bytes";

task("setchainperson", "Set chain person role in NFT", async (args, hre) => {
  const [addr1, addr2, addr3, ...addrs] = await hre.ethers.getSigners();

  const bridge = await hre.ethers.getContractAt("Bridge", process.env.BRIDGE_ADDR as string);
  await bridge.connect(addr1).setChairePersonRole(addr3.address);

  console.log('setchainperson task Done!'); 
});