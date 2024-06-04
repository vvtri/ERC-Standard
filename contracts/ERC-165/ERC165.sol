// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import './IERC165.sol';

abstract contract ERC165 is IERC165 {
  function supportsInterface(
    bytes4 interfaceID
  ) public view virtual returns (bool) {
    return type(IERC165).interfaceId == interfaceID;
  }
}
