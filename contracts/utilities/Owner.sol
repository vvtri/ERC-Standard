// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Owner {
  address private _owner;

  constructor() {
    _owner = msg.sender;
  }

  modifier onwerOnly() {
    require(msg.sender == _owner, 'msg.sender == _owner');
    _;
  }
}
