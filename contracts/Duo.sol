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

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnd = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable notPaused {
        require(
            presaleStarted && block.timestamp < presaleEnd,
            "presale is not active"
        );
        require(whitelist.allowedAddresses(msg.sender), "you are not allowed");
        require(numTokenIds < maxTokenIds, "minted out!");
        require(msg.value >= _price, "not enough funds");
        numTokenIds++;

        _safeMint(msg.sender, numTokenIds);
    }

    function mint() public payable {
        require(
            presaleStarted && block.timestamp >= presaleEnd,
            "presale is continuing"
        );
        require(numTokenIds < maxTokenIds, "minted out!");
        require(msg.value >= _price, "not enough funds");
        numTokenIds++;
        _safeMint(msg.sender, numTokenIds);
    }

    /**
     * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
     * returned an empty string for the baseURI
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}
}
