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

contract TestDSMath {
	function test_add() {
		Assert.equal(uint(DSMath.add(0, 1)), 1, "0+1 should equal 1");
		Assert.equal(uint(DSMath.add(1, 1)), 2, "1+1 should equal 2");
	}

	function test_sub() {
		Assert.equal(uint(DSMath.sub(0, 0)), 0, "0-0 should equal 0");
		Assert.equal(uint(DSMath.sub(1, 1)), 0, "1-1 should equal 0");
		Assert.equal(uint(DSMath.sub(2, 1)), 1, "2-1 should equal 1");
	}

	function test_mul() {
		Assert.equal(uint(DSMath.mul(0, 1)), 0, "0*1 should equal 0");
		Assert.equal(uint(DSMath.mul(1, 1)), 1, "1*1 should equal 1");
		Assert.equal(uint(DSMath.mul(2, 1)), 2, "2*1 should equal 2");
	}

	function test_div() {
		Assert.equal(uint(DSMath.div(0, 1)), 0, "0/1 should equal 0");
		Assert.equal(uint(DSMath.div(1, 1)), 1, "1/1 should equal 1");
		Assert.equal(uint(DSMath.div(4, 2)), 2, "4/2 should equal 2");
	}

	function test_min() {
		Assert.equal(uint(DSMath.min(1, 1)), 1, "min(1,1) should equal 1");
		Assert.equal(uint(DSMath.min(1, 2)), 1, "min(1,2) should equal 2");
	}

	function test_max() {
		Assert.equal(uint(DSMath.max(1, 1)), 1, "max(1,1) should equal 1");
		Assert.equal(uint(DSMath.max(1, 2)), 2, "max(1,2) should equal 2");
	}

	function test_wdiv_trivial() {
		Assert.equal(uint(DSMath.wdiv(0.0 ether, 1.0 ether)), 0.0 ether, "0.0/1.0 should equal 0.0");
		Assert.equal(uint(DSMath.wdiv(1.0 ether, 1.0 ether)), 1.0 ether, "1.0*1.0 should equal 1.0");
	}

	function test_hadd() {
		Assert.equal(uint(DSMath.hadd(0, 0)), 0, "0+0 should equal 0");
		Assert.equal(uint(DSMath.hadd(0, 1)), 1, "0+1 should equal 1");
		Assert.equal(uint(DSMath.hadd(1, 1)), 2, "1+1 should equal 2");
	}

	function test_hsub() {
		Assert.equal(uint(DSMath.hsub(0, 0)), 0, "0-0 should equal 0");
		Assert.equal(uint(DSMath.hsub(1, 1)), 0, "1-1 should equal 0");
		Assert.equal(uint(DSMath.hsub(2, 1)), 1, "2-1 should equal 1");
	}

	function test_hmul() {
		Assert.equal(uint(DSMath.hmul(0, 1)), 0, "0*1 should equal 0");
		Assert.equal(uint(DSMath.hmul(1, 1)), 1, "1*1 should equal 1");
		Assert.equal(uint(DSMath.hmul(2, 1)), 2, "2*1 should equal 2");
	}

	function test_hdiv() {
		Assert.equal(uint(DSMath.hdiv(0, 1)), 0, "0/1 should equal 0");
		Assert.equal(uint(DSMath.hdiv(1, 1)), 1, "1/1 should equal 1");
		Assert.equal(uint(DSMath.hdiv(4, 2)), 2, "4/2 should equal 2");
	}

	function test_hmin() {
		Assert.equal(uint(DSMath.hmin(1, 1)), 1, "hmin(1,1) should equal 1");
		Assert.equal(uint(DSMath.hmin(1, 2)), 1, "hmin(1,2) should equal 1");
	}

	function test_hmax() {
		Assert.equal(uint(DSMath.hmax(1, 1)), 1, "hmax(1,1) should equal 1");
		Assert.equal(uint(DSMath.hmax(1, 2)), 2, "hmax(1,2) should equal 2");
	}

	function test_imin() {
		Assert.equal(int(DSMath.imin(1, 1)), 1, "imin(1,1) should equal 1");
		Assert.equal(int(DSMath.imin(1, 2)), 1, "imin(1,2) should equal 1");
		Assert.equal(int(DSMath.imin(1, -2)), -2, "imin(1,-2) should equal -2");
	}

	function test_imax() {
		Assert.equal(int(DSMath.imax(1, 1)), 1, "imax(1,1) should equal 1");
		Assert.equal(int(DSMath.imax(1, 2)), 2, "imax(1,2) should equal 2");
		Assert.equal(int(DSMath.imax(1, -2)), 1, "imax(1,-2) should equal 1");
	}

	function test_wmul_trivial() {
		Assert.equal(uint(DSMath.wmul(2 ** 128 - 1, 1.0 ether)), 2 ** 128 - 1, "(2**128 - 1)*1 should equal 2**128 - 1");
		Assert.equal(uint(DSMath.wmul(0.0 ether, 0.0 ether)), 0.0 ether, "0.0*0.0 should equal 0.0");
		Assert.equal(uint(DSMath.wmul(0.0 ether, 1.0 ether)), 0.0 ether, "0.0*1.0 should equal 0.0");
		Assert.equal(uint(DSMath.wmul(1.0 ether, 0.0 ether)), 0.0 ether, "1.0*0.0 should equal 0.0");
		Assert.equal(uint(DSMath.wmul(1.0 ether, 1.0 ether)), 1.0 ether, "1.0*1.0 should equal 1.0");
	}

	function test_wmul_fractions() {
		Assert.equal(uint(DSMath.wmul(1.0 ether, 0.2 ether)), 0.2 ether, "1.0*0.2 should equal 0.2");
		Assert.equal(uint(DSMath.wmul(2.0 ether, 0.2 ether)), 0.4 ether, "2.0*0.2 should equal 0.4");
	}

	function test_wdiv_fractions() {
		Assert.equal(uint(DSMath.wdiv(1.0 ether, 2.0 ether)), 0.5 ether, "1.0/2.0 should equal 0.5");
		Assert.equal(uint(DSMath.wdiv(2.0 ether, 2.0 ether)), 1.0 ether, "2.0*2.0 should equal 1.0");
	}    
}