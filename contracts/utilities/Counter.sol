// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// import "@openzeppelin/contracts/utils/Counters.sol";

struct Counter {
  uint256 _value;
}

library Counters {
  function _current(Counter storage counter) internal view returns (uint256) {
    return counter._value;
  }

  function _increment(Counter storage counter) internal {
    counter._value = counter._value + 1;
  }
}
