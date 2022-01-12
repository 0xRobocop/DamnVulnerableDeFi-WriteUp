// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Address.sol";

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

/**
 * @title SideEntranceLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract SideEntranceLenderPool {
    using Address for address payable;

    mapping (address => uint256) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amountToWithdraw = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).sendValue(amountToWithdraw);
    }

    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= amount, "Not enough ETH in balance");

        // The attack is that during the execute function we can call deposit()
        // and the pool do not have a way to distinguish between repaying the loan
        // and depositing money that comes from the flash loan

        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();

        // One way to fix this contract is maybe use something a variable to track the balance
        // of the pool only from deposits, and add an assert than during a flashloan this variable
        // remain the same.

        require(address(this).balance >= balanceBefore, "Flash loan hasn't been paid back");
    }
}
