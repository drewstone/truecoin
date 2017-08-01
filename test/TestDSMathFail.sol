// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

pragma solidity ^0.4.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DSMath.sol";

contract TestDSMathFail {

	// uint256 tests

	function testFail_add() {
		DSMath.add(2 ** 256 - 1, 1);
	}

	function testFail_sub() {
		DSMath.sub(0, 1);
	}

	function testFail_mul() {
		DSMath.mul(2 ** 254, 6);
	}

	function testFail_div() {
		DSMath.div(0, 0);
	}

	// uint128 tests

	function testFail_hadd() {
		DSMath.hadd(2 ** 128 - 1, 1);
	}

	function testFail_hsub() {
		DSMath.hsub(0, 1);
	}

	function testFail_hmul() {
		DSMath.hmul(2 ** 128 -1, 2);
	}


	function testFail_hdiv() {
		DSMath.hdiv(0, 0);
	}

	function testFail_wmul_overflow() {
		DSMath.wmul(2 ** 128 - 1, 1.0 ether + 1 wei);
	}


	function testFail_wdiv_zero() {
		DSMath.wdiv(1.0 ether, 0.0 ether);
	}
}