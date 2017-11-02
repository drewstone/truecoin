// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

pragma solidity ^0.4.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/math/MathLib.sol";

contract TestMathLibFail {

	// uint256 tests

	function testFail_add() {
		MathLib.add(2 ** 256 - 1, 1);
	}

	function testFail_sub() {
		MathLib.sub(0, 1);
	}

	function testFail_mul() {
		MathLib.mul(2 ** 254, 6);
	}

	function testFail_div() {
		MathLib.div(0, 0);
	}

	// uint128 tests

	function testFail_hadd() {
		MathLib.hadd(2 ** 128 - 1, 1);
	}

	function testFail_hsub() {
		MathLib.hsub(0, 1);
	}

	function testFail_hmul() {
		MathLib.hmul(2 ** 128 -1, 2);
	}


	function testFail_hdiv() {
		MathLib.hdiv(0, 0);
	}

	function testFail_wmul_overflow() {
		MathLib.wmul(2 ** 128 - 1, 1.0 ether + 1 wei);
	}


	function testFail_wdiv_zero() {
		MathLib.wdiv(1.0 ether, 0.0 ether);
	}
}