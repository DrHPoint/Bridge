import { task } from "hardhat/config";
import { parseUnits } from "ethers/lib/utils";
//import { ethers } from "hardhat";
//import { hexConcat } from "@ethersproject/bytes";

task("redeem", "Redeem swap between chains")
.addParam("index", "NFT index")
.addParam("owner", "owner of NFT token")
.addParam("chainid", "chaind from")
.addParam("nonce", "just nonce")
.setAction(async (taskArgs, hre) => {
    const [addr1, addr2, addr3, ...addrs] = await hre.ethers.getSigners();
    const nft = await hre.ethers.getContractAt("NFT", process.env.NFT_ADDR as string);
    const bridge = await hre.ethers.getContractAt("Bridge", process.env.BRIDGE_ADDR as string);
    const signedDataHash = hre.ethers.utils.solidityKeccak256(
    ["uint256", "address", "uint256", "uint256", "uint256"],
    [taskArgs.index, addr1.address, taskArgs.nonce, taskArgs.chainid, 4]
    );
    console.log("4");
    const bytesArray = hre.ethers.utils.arrayify(signedDataHash);
    const flatSignature1 = await addr3.signMessage(bytesArray);
    const signature1 = hre.ethers.utils.splitSignature(flatSignature1);
    await bridge.connect(addr3).redeem(taskArgs.index, taskArgs.owner as string, taskArgs.chainid, taskArgs.nonce, signature1.v, signature1.r, signature1.s);
    console.log('redeem task Done!'); 
});