//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721, AccessControl {
    bytes32 public constant BRIDGE_ROLE = keccak256("BRIDGE_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC721("MyToken", "MTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(BRIDGE_ROLE, msg.sender);
    }

    function mint(address _to, uint256 _tokenId) public onlyRole(MINTER_ROLE) {
        _safeMint(_to, _tokenId);
    }

    function burn(uint256 _tokenId) public onlyRole(BRIDGE_ROLE) {
        _burn(_tokenId);
    }

    function setBridgeRole(address _bridge) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(BRIDGE_ROLE, _bridge);
        _grantRole(MINTER_ROLE, _bridge);
    }

    function setMinterRole(address _newMinter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, _newMinter);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

