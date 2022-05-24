//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

interface IERC721 is IERC165 {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function approve(address _approved, uint256 _tokenId) external payable;

    function getApproved(uint256 _tokenId) external view returns (address);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes data
    ) external payable;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface ERC721TokenReceiver {
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes _data
    ) external returns (bytes4);
}
