pragma solidity ^0.4.4;

import './Mechanism.sol';
import "./DSMath.sol";

library BayesianTruthMechanism {
	using Mechanism for Mechanism.M;

	struct Manager {
		Mechanism.M mechanism;
		uint128[] scores;
		uint128 playerlimit;
	}

	function init(Manager storage self, uint128 numseconds, uint128 playerlimit) {
		if (self.mechanism.parentContract != address(0x0)) {
			throw;
		}

		self.mechanism.init(numseconds);
		self.playerlimit = playerlimit;
	}

	function submit(Manager storage self, address voter, uint128 i, uint128 p) {
		if (self.mechanism.participants.length >= self.playerlimit) {
			throw;
		}

		self.mechanism.submit(voter, i, p);
	}

	function score(Manager storage self) constant returns(uint128[], uint128) {
		if (self.mechanism.expirationTime <= now) {
			throw;
		}

		uint128[] scores = self.scores;

		for (uint i = 0; i < scores.length; i++) {
			uint128 informationScore;
			uint128 predictionScore;

			uint128 referenceAgent = uint128((i+1) % scores.length);
			uint128 peerAgent = uint128((i+2) % scores.length);

			uint128 meta = self.mechanism.metaPreds[referenceAgent];
			uint128 delta = DSMath.wmin(meta, DSMath.wmin(1 ether, meta));

			if (self.mechanism.binaryPreds[i] == 0) {
				informationScore = RBTSQuadraticScoring(
					self.mechanism.binaryPreds[peerAgent] * 1 ether,
					DSMath.wsub(meta, delta)
				);
			} else {
				informationScore = RBTSQuadraticScoring(
					self.mechanism.binaryPreds[peerAgent] * 1 ether,
					DSMath.wadd(meta, delta)
				);
			}

			predictionScore = RBTSQuadraticScoring(
				self.mechanism.binaryPreds[peerAgent],
				self.mechanism.metaPreds[i]
			);

			scores.push(DSMath.wadd(informationScore, predictionScore));
		}

		return (scores, 1 ether);
	}

	function RBTSQuadraticScoring(uint128 i, uint128 p) constant returns(uint128) {
		if (i == 0) {
			return uint128(DSMath.wsub(DSMath.wmul(2 * 1 ether, p), DSMath.wmul(p, p)));
		} else {
			return uint128(DSMath.wsub(1 ether,DSMath.wmul(p, p)));
		}
	}
}