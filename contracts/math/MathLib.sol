/// math.sol -- mixin for inline numerical wizardry

// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

pragma solidity ^0.4.10;

library MathLib {
	function add(uint256 x, uint256 y) internal constant returns (uint256 z) {
		assert((z = x + y) >= x);
	}

	function sub(uint256 x, uint256 y) internal constant returns (uint256 z) {
		assert((z = x - y) <= x);
	}

	function mul(uint256 x, uint256 y) internal constant returns (uint256 z) {
		z = x * y;
		assert(x == 0 || z / x == y);
	}

	function div(uint256 x, uint256 y) internal constant returns (uint256 z) {
		z = x / y;
	}

	function min(uint256 x, uint256 y) internal constant returns (uint256 z) {
		return x <= y ? x : y;
	}
	function max(uint256 x, uint256 y) internal constant returns (uint256 z) {
		return x >= y ? x : y;
	}

	/*
	uint128 functions (h is for half)
	 */


	function hadd(uint128 x, uint128 y) internal constant returns (uint128 z) {
		assert((z = x + y) >= x);
	}

	function hsub(uint128 x, uint128 y) internal constant returns (uint128 z) {
		assert((z = x - y) <= x);
	}

	function hmul(uint128 x, uint128 y) internal constant returns (uint128 z) {
		z = x * y;
		assert(x == 0 || z / x == y);
	}

	function hdiv(uint128 x, uint128 y) internal constant returns (uint128 z) {
		z = x / y;
	}

	function hmin(uint128 x, uint128 y) internal constant returns (uint128 z) {
		return x <= y ? x : y;
	}
	function hmax(uint128 x, uint128 y) internal constant returns (uint128 z) {
		return x >= y ? x : y;
	}


	/*
	int256 functions
	 */

	function imin(int256 x, int256 y) internal constant returns (int256 z) {
		return x <= y ? x : y;
	}
	function imax(int256 x, int256 y) internal constant returns (int256 z) {
		return x >= y ? x : y;
	}

	/*
	WAD math
	 */

	uint128 constant WAD = 10 ** 18;

	function wadd(uint128 x, uint128 y) internal constant returns (uint128) {
		return hadd(x, y);
	}

	function wsub(uint128 x, uint128 y) internal constant returns (uint128) {
		return hsub(x, y);
	}

	function wmul(uint128 x, uint128 y) internal constant returns (uint128 z) {
		z = cast((uint256(x) * y + WAD / 2) / WAD);
	}

	function wdiv(uint128 x, uint128 y) internal constant returns (uint128 z) {
		z = cast((uint256(x) * WAD + y / 2) / y);
	}

	function wmin(uint128 x, uint128 y) internal constant returns (uint128) {
		return hmin(x, y);
	}
	function wmax(uint128 x, uint128 y) internal constant returns (uint128) {
		return hmax(x, y);
	}

	/*
	RAY math
	 */

	uint128 constant RAY = 10 ** 27;

	function radd(uint128 x, uint128 y) internal constant returns (uint128) {
		return hadd(x, y);
	}

	function rsub(uint128 x, uint128 y) internal constant returns (uint128) {
		return hsub(x, y);
	}

	function rmul(uint128 x, uint128 y) internal constant returns (uint128 z) {
		z = cast((uint256(x) * y + RAY / 2) / RAY);
	}

	function rdiv(uint128 x, uint128 y) internal constant returns (uint128 z) {
		z = cast((uint256(x) * RAY + y / 2) / y);
	}

	function rpow(uint128 x, uint64 n) internal constant returns (uint128 z) {
		// This famous algorithm is called "exponentiation by squaring"
		// and calculates x^n with x as fixed-point and n as regular unsigned.
		//
		// It's O(log n), instead of O(n) for naive repeated multiplication.
		//
		// These facts are why it works:
		//
		//  If n is even, then x^n = (x^2)^(n/2).
		//  If n is odd,  then x^n = x * x^(n-1),
		//   and applying the equation for even x gives
		//    x^n = x * (x^2)^((n-1) / 2).
		//
		//  Also, EVM division is flooring and
		//    floor[(n-1) / 2] = floor[n / 2].

		z = n % 2 != 0 ? x : RAY;

		for (n /= 2; n != 0; n /= 2) {
			x = rmul(x, x);

			if (n % 2 != 0) {
				z = rmul(z, x);
			}
		}
	}

	function rmin(uint128 x, uint128 y) internal constant returns (uint128) {
		return hmin(x, y);
	}
	function rmax(uint128 x, uint128 y) internal constant returns (uint128) {
		return hmax(x, y);
	}

	function cast(uint256 x) internal constant returns (uint128 z) {
		assert((z = uint128(x)) == x);
	}

	function sum(uint[] a) internal constant returns (uint sum) {
		for (uint i = 0; i < a.length; i++) {
			sum = add(sum, a[i]); 
		}
	}

	function getDistinctElements(uint[] a, uint[] b) internal constant returns (uint[], uint[]) {
		uint dups = 0;
		bool[] memory aDup = new bool[](a.length);
		bool[] memory bDup = new bool[](b.length);
		
		for (uint i = 0; i < a.length; i++) {
			for (uint j = 0; j < b.length; j++) {
				if (a[i] == b[j]) {
					aDup[i] = true;
					dups = dups + 1;
				}
			}
		}
		
		if (dups == b.length) {
			return (new uint[](0), new uint[](0));
		}
		
		for (i = 0; i < b.length; i++) {
			for (j = 0; j < a.length; j++) {
				if (b[i] == a[j]) {
					bDup[i] = true;
				}
			}
		}

		uint min = DSMath.min(a.length, b.length) - dups;
		uint[] memory aDistinct = new uint[](min);
		uint[] memory bDistinct = new uint[](min);
		uint counter = 0;

		for (i = 0; i < a.length; i++) {
			if (!aDup[i] && counter != min) {
				aDistinct[counter++] = a[i];
			}
		}
		
		counter = 0;
		for (i = 0; i < b.length; i++) {
			if (!bDup[i] && counter != min) {
				bDistinct[counter++] = b[i];
			}
		}

		return (aDistinct, bDistinct);
	}
}
