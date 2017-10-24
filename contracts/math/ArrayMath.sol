pragma solidity ^0.4.11;


/**
 * @title ArrayMath
 * @dev Math operations on arrays
 */
library ArrayMath {
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