//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./NFT.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Bridge is AccessControl, ERC721Holder {
    using ECDSA for bytes32;
    enum status { EMPTY, SWAPED, REDEEMED }
    bytes32 public constant CHAIR_PERSON = keccak256("CHAIR_PERSON");
    address public ownerNFT;
    uint256 public chainId;
    mapping (bytes32 => status) swaps;
    

    constructor(address _nftAddress, uint256 _chainId) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(CHAIR_PERSON, msg.sender);
        ownerNFT = _nftAddress;
        chainId = _chainId;
    }

    event swapInitialized(uint256 _itemId, address _owner, uint256 _chainIDfrom, uint256 _chainIDto);

    function swap(uint256 _itemId, uint256 _chainIdTo, uint256 nonce) external {
        require(NFT(ownerNFT).ownerOf(_itemId) == msg.sender, "User has no rights to this token");
        bytes32 dataHash = keccak256(
            abi.encodePacked(_itemId, msg.sender, nonce, chainId, _chainIdTo)
        );
        swaps[dataHash] = status.SWAPED;
        NFT(ownerNFT).burn(_itemId);
        emit swapInitialized(_itemId, msg.sender, chainId, _chainIdTo);
    }

    function redeem(uint256 _itemId, address _owner, uint256 _chainIdFrom, uint256 nonce,
                uint8 v, bytes32 r, bytes32 s) external onlyRole(CHAIR_PERSON){
        
        bytes32 dataHash = keccak256(
            abi.encodePacked(_itemId, _owner, nonce, _chainIdFrom, chainId)
        );
        require(ECDSA.recover(dataHash.toEthSignedMessageHash(), v, r, s) == (msg.sender), "Signature is wrong");
        require(swaps[dataHash] != status.REDEEMED);
        swaps[dataHash] = status.REDEEMED;
        NFT(ownerNFT).mint(_owner, _itemId);
    }

    function setChairePersonRole(address _newMinter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(CHAIR_PERSON, _newMinter);
    }

    
}
