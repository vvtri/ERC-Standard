// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import 'hardhat/console.sol';

contract Reentrance {
  bool public isEntranced;

  modifier noReentrance() {
    require(!isEntranced, 'You can not re entrance');
    isEntranced = true;
    _;
    isEntranced = false;
  }
}

contract Contract1 {
  function callTo2(address c2) public {
    Contract2(c2).dangrousMethod(0);
  }

  function doSomeThing() public {
    console.log('doSomeThing ', msg.sender);
    callTo2(msg.sender);
  }
}

contract Contract2 is Reentrance {
  uint256 public money = 10;

  function callTo1(address c1) public noReentrance {
    Contract1(c1).doSomeThing();
  }

  function dangrousMethod(uint256 _money) public noReentrance {
    money = _money;
  }
}
