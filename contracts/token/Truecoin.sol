pragma solidity ^0.4.10;

import 'zeppelin/contracts/token/MintableToken.sol';

/**
 * This contract is TRUECOIN YO
 */
contract Truecoin is MintableToken {
	function Truecoin(uint initialBalance) {
		balances[msg.sender] = initialBalance;
    	totalSupply = initialBalance;
	}
}
