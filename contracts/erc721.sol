//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.2;

contract ERC721 {
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 _tokenId
    );

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _token
    );

    mapping(address => uint256) internal balances;
    mapping(uint256 => address) internal owners;
    mapping(address => mapping(address => bool)) private operatorApprovals;
    mapping(uint256 => address) private tokenApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "Address is zero");
        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = owners[_tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    // Update the approved address for an NFT
    function approve(address _approved, uint256 _tokenId) public payable {
        address owner = ownerOf(_tokenId);
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Msg.sender is not the owner"
        );
        tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    // Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    function setApprovalForAll(address _operator, bool _approved) external {
        operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    // Query if an address is an authorized operator for another address
    function isApprovedForAll(address _owner, address _operator)
        public
        view
        returns (bool)
    {
        return operatorApprovals[_owner][_operator];
    }

    // Get the approved address for a single NFT
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(owners[_tokenId] != address(0), "Token does not exist");
        return tokenApprovals[_tokenId];
    }

    // Transfer ownership of an NFT
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable {
        address owner = ownerOf(_tokenId);
        require(
            msg.sender == owner ||
                getApproved(_tokenId) == msg.sender ||
                isApprovedForAll(owner, msg.sender),
            "The msg.sender is not the owner or approved for transfer"
        );
        require(_from == owner, "From address is not the owner");
        require(_to != address(0), "Address is zero");
        require(owners[_tokenId] != address(0), "Token ID does not exist");

        approve(address(0), _tokenId);
        balances[_from] -= 1;
        balances[_to] += 1;
        owners[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) public payable {
        transferFrom(_from, _to, _tokenId);
        require(_checkOnERC721Received(), "Receiver not implemented");
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    // Not implemented
    function _checkOnERC721Received() private pure returns (bool) {
        return true;
    }

    // EIP165: Query if a contract implements another interface
    function supportsInterface(bytes4 interfaceId)
        public
        pure
        virtual
        returns (bool)
    {
        return interfaceId == 0x80ac58cd;
    }
}
