// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract ReentranceGuard {
  uint8 private constant ENTERED = 2;
  uint8 private constant NOT_ENTERED = 1;
  uint256 private status;

  modifier notReentrance() {
    require(status == NOT_ENTERED, 'You are not allowed to call back');
    status = ENTERED;

    _;

    status = NOT_ENTERED;
  }
}
