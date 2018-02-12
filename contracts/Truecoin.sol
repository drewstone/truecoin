pragma solidity ^0.4.10;

import './MintableToken.sol';
import './ERC827Token.sol';

/**
 * This contract is TRUECOIN YO
 */
contract Truecoin is ERC827Token {
	function Truecoin(uint initialBalance) public {
		balances[msg.sender] = initialBalance;
		totalSupply_ = initialBalance;
	}
}
