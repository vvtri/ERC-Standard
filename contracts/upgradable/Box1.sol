// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';

contract Box1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
  uint256 public val;

  event Initialize(address sender, uint val);

  function _authorizeUpgrade(
    address newImplementation
  ) internal override onlyOwner {}

  function initialize(uint _val) external initializer {
    OwnableUpgradeable.__Ownable_init(msg.sender);

    val = _val;

    emit Initialize(msg.sender, val);
  }

  function setVal(uint256 _val) public {
    val = _val;
  }

  function getVal() public view returns (uint256) {
    return val;
  }
}
