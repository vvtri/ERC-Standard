// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import './ERC721.sol';
import '../utilities/Counter.sol';
import '../utilities/Owner.sol';

contract ImplementERC721 is ERC721, Owner {
  using Counters for Counter;
  Counter private _tokenIds;

  constructor() ERC721('Test collection', 'TE') Owner() {}

  function mintTo(address _to, string memory uri) public {
    _tokenIds._increment();
    _mint(_to, _tokenIds._current());
    _setTokenURI(_tokenIds._current(), uri);
  }

  function burn(uint256 tokenId) public {
    _burn(tokenId);
  }
}
