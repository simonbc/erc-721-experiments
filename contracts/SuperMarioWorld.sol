//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.2;

import "./erc721.sol";

contract SuperMarioWorld is ERC721 {
    string public name;
    string public symbol;
    uint256 public tokenCount;
    mapping(uint256 => string) private tokenURIs;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(ownerOf(_tokenId) != address(0), "Token does not exist");
        return tokenURIs[_tokenId];
    }

    function mint(string memory _tokenURI) external {
        tokenCount += 1;
        balances[msg.sender] += 1;
        owners[tokenCount] = msg.sender;
        tokenURIs[tokenCount] = _tokenURI;
        emit Transfer(address(0), msg.sender, tokenCount);
    }

    // EIP165: Query if a contract implements another interface
    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override
        returns (bool)
    {
        return interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;
    }
}
