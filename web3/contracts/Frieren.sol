// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Frieren is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint256 public MAX_SUPPLY = 1000;
    bool public publicMintOpen = false;
    bool public allowMintOpen = false;
    bool public presaleMintOpen = false;
    mapping(address => bool) public allowList;

    constructor(address initialOwner)
        ERC721("Frieren", "FRIEN")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmXxQ85puyoS2TGEA3amFebzpHsWLcoUpqQaxpDeyYvMaS/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // modify the mint windows
    function editMintWindows(
        bool _publicMintOpen,
        bool _allowMintOpen,
        bool _presaleMintOpen
    ) external onlyOwner {
        publicMintOpen = _publicMintOpen;
        allowMintOpen = _allowMintOpen;
        presaleMintOpen = _presaleMintOpen;
    }

    // add presale
    function presaleMint() public payable {
        require(presaleMintOpen, "presale closed");
        require(totalSupply() < 100, "Presale has closed");
        require(
            msg.value >= 0.001 ether && msg.value <= 0.002 ether,
            "not enough funds"
        );
        internalMint();
    }

    // add allowlistmint
    // msg.value must be 1000001
    function allowListMint() public payable {
        require(allowMintOpen, "allowlis mint Closed, wait me to season 2");
        require(allowList[msg.sender], "You are not Allowed");
        require(
            msg.value >= 0.0001 ether && msg.value <= 0.0002 ether,
            "not enough funds"
        );
        internalMint();
    }

    // add payment
    function publicMint() public payable {
        require(publicMintOpen, "public Mint Closed");
        require(
            msg.value >= 0.01 ether && msg.value <= 0.02 ether,
            "not enough funds"
        );
        internalMint();
    }

    function internalMint() internal {
        require(totalSupply() < MAX_SUPPLY, "Sold Out");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    // withdraw function
    function withdraw(address payable _addr) external onlyOwner {
        uint256 balance = address(this).balance;
        _addr.transfer(balance);
    }

    // populate allow list mint
    function setAllowList(address[] calldata addr) external onlyOwner {
        for (uint256 i = 0; i < addr.length; i++) {
            allowList[addr[i]] = true;
        }
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
