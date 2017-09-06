pragma solidity ^0.4.10;

import './MintableToken.sol';
import './CrowdsaleToken.sol';

/**
 * This contract is TRUECOIN YO
 */
contract Truecoin is MintableToken {
	function Truecoin(uint totalSupply) {
		balances[protocol] = initialBalance;
    	totalSupply = initialBalance;
	}
}
