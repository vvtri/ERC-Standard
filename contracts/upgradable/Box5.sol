// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// import '@openzeppelin/contracts/access/Ownable.sol';
// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Box5 {
  // uint256 public val = 123;
  uint256 public val;
  uint256 public val2;
  address public owner;
  address public owner3;

  event Initialize(address sender, uint val);

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function initialize(uint _val) external {
    revert('what happen?');
    require(
      msg.sender == owner3 || owner3 == address(0),
      'msg.sender == owner3 || owner3 == address(0)'
    );
    val2 = _val;
    owner3 = msg.sender;
    emit Initialize(msg.sender, val);
  }

  function setVal(uint256 _val) public {
    val = _val;
  }

  function setVal2(uint256 _val) public onlyOwner {
    val = _val;
  }

  function getVal() public view returns (uint256) {
    return val;
  }
}
