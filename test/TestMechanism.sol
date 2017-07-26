pragma solidity ^0.4.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DSMath.sol";
import "../contracts/Mechanism.sol";

contract TestMechanism {
    using Mechanism for Mechanism.M;

    function test_quadratic_scoring_fn_with_1() {        
        uint128 info1 = 1 ether;
        uint128 pred1 = 0.25 ether;

        uint quad_for_1 = uint(DSMath.hsub(DSMath.wmul(2 ether, pred1), DSMath.wmul(pred1, pred1)));

        Assert.equal(quad_for_1, 0.4375 ether, "WORK");
    }

    function test_quadratic_scoring_fn_with_0() {        
        uint128 info1 = 0 ether;
        uint128 pred1 = 0.25 ether;

        uint quad_for_0 = uint(DSMath.hsub(1.0 ether, DSMath.wmul(pred1, pred1)));

        Assert.equal(quad_for_0, 0.9375 ether, "WORK");
    }

    function test_mechanism() {
        Mechanism.M mechanism;
        mechanism.init(10);

        Assert.equal(mechanism.getParent(), address(this), "Parent contract should be test contract");
    }
}
