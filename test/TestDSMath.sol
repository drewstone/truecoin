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
    // uint256 tests

    function test_add() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.add(0, 1)), 1, "0+1 should equal 1");
        Assert.equal(uint(ds.add(1, 1)), 2, "1+1 should equal 2");
    }

    function test_sub() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.sub(0, 0)), 0, "0-0 should equal 0");
        Assert.equal(uint(ds.sub(1, 1)), 0, "1-1 should equal 0");
        Assert.equal(uint(ds.sub(2, 1)), 1, "2-1 should equal 1");
    }

    function test_mul() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.mul(0, 1)), 0, "0*1 should equal 0");
        Assert.equal(uint(ds.mul(1, 1)), 1, "1*1 should equal 1");
        Assert.equal(uint(ds.mul(2, 1)), 2, "2*1 should equal 2");
    }

    function test_div() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.div(0, 1)), 0, "0/1 should equal 0");
        Assert.equal(uint(ds.div(1, 1)), 1, "1/1 should equal 1");
        Assert.equal(uint(ds.div(4, 2)), 2, "4/2 should equal 2");
    }

    function test_min() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.min(1, 1)), 1, "min(1,1) should equal 1");
        Assert.equal(uint(ds.min(1, 2)), 1, "min(1,2) should equal 2");
    }

    function test_max() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.max(1, 1)), 1, "max(1,1) should equal 1");
        Assert.equal(uint(ds.max(1, 2)), 2, "max(1,2) should equal 2");
    }

    function test_wdiv_trivial() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.wdiv(0.0 ether, 1.0 ether)), 0.0 ether, "0.0/1.0 should equal 0.0");
        Assert.equal(uint(ds.wdiv(1.0 ether, 1.0 ether)), 1.0 ether, "1.0*1.0 should equal 1.0");
    }

    function test_hadd() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.hadd(0, 0)), 0, "0+0 should equal 0");
        Assert.equal(uint(ds.hadd(0, 1)), 1, "0+1 should equal 1");
        Assert.equal(uint(ds.hadd(1, 1)), 2, "1+1 should equal 2");
    }

    function test_hsub() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.hsub(0, 0)), 0, "0-0 should equal 0");
        Assert.equal(uint(ds.hsub(1, 1)), 0, "1-1 should equal 0");
        Assert.equal(uint(ds.hsub(2, 1)), 1, "2-1 should equal 1");
    }

    function test_hmul() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.hmul(0, 1)), 0, "0*1 should equal 0");
        Assert.equal(uint(ds.hmul(1, 1)), 1, "1*1 should equal 1");
        Assert.equal(uint(ds.hmul(2, 1)), 2, "2*1 should equal 2");
    }

    function test_hdiv() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.hdiv(0, 1)), 0, "0/1 should equal 0");
        Assert.equal(uint(ds.hdiv(1, 1)), 1, "1/1 should equal 1");
        Assert.equal(uint(ds.hdiv(4, 2)), 2, "4/2 should equal 2");
    }

    function test_hmin() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.hmin(1, 1)), 1, "hmin(1,1) should equal 1");
        Assert.equal(uint(ds.hmin(1, 2)), 1, "hmin(1,2) should equal 1");
    }

    function test_hmax() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.hmax(1, 1)), 1, "hmax(1,1) should equal 1");
        Assert.equal(uint(ds.hmax(1, 2)), 2, "hmax(1,2) should equal 2");
    }

    // int256 tests

    function test_imin() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(int(ds.imin(1, 1)), 1, "imin(1,1) should equal 1");
        Assert.equal(int(ds.imin(1, 2)), 1, "imin(1,2) should equal 1");
        Assert.equal(int(ds.imin(1, -2)), -2, "imin(1,-2) should equal -2");
    }

    function test_imax() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(int(ds.imax(1, 1)), 1, "imax(1,1) should equal 1");
        Assert.equal(int(ds.imax(1, 2)), 2, "imax(1,2) should equal 2");
        Assert.equal(int(ds.imax(1, -2)), 1, "imax(1,-2) should equal 1");
    }

    function test_wmul_trivial() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.wmul(2 ** 128 - 1, 1.0 ether)), 2 ** 128 - 1, "(2**128 - 1)*1 should equal 2**128 - 1");
        Assert.equal(uint(ds.wmul(0.0 ether, 0.0 ether)), 0.0 ether, "0.0*0.0 should equal 0.0");
        Assert.equal(uint(ds.wmul(0.0 ether, 1.0 ether)), 0.0 ether, "0.0*1.0 should equal 0.0");
        Assert.equal(uint(ds.wmul(1.0 ether, 0.0 ether)), 0.0 ether, "1.0*0.0 should equal 0.0");
        Assert.equal(uint(ds.wmul(1.0 ether, 1.0 ether)), 1.0 ether, "1.0*1.0 should equal 1.0");
    }

    function test_wmul_fractions() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.wmul(1.0 ether, 0.2 ether)), 0.2 ether, "1.0*0.2 should equal 0.2");
        Assert.equal(uint(ds.wmul(2.0 ether, 0.2 ether)), 0.4 ether, "2.0*0.2 should equal 0.4");
    }

    function test_wdiv_fractions() {
        DSMath ds = DSMath(DeployedAddresses.DSMath());

        Assert.equal(uint(ds.wdiv(1.0 ether, 2.0 ether)), 0.5 ether, "1.0/2.0 should equal 0.5");
        Assert.equal(uint(ds.wdiv(2.0 ether, 2.0 ether)), 1.0 ether, "2.0*2.0 should equal 1.0");
    }    
}