// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IUnus.sol";

contract Duo is ERC721Enumerable, Ownable {
    string _baseTokenURI;

    uint256 public _price = 0.005 ether;

    bool public _paused;

    uint256 public maxTokenIds = 10;

    uint256 public numTokenIds;

    IUnus whitelist;

    bool public presaleStarted;

    uint256 public presaleEnd;

    modifier notPaused() {
        require(!_paused, "contract is paused");
        _;
    }

    constructor(string memory baseURI, address whitelistContract)
        ERC721("NFT Example", "NEX")
    {
        _baseTokenURI = baseURI;
        whitelist = IUnus(whitelistContract);
    }
}
