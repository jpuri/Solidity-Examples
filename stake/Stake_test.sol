// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "remix_tests.sol";
import "remix_accounts.sol";
import "../contracts/Stake.sol";

contract StakeTokenTest is StakeToken {
   
    constructor() StakeToken('Stake Token', 'STK', 10000) {
    }

    function checkCreateStake () public {
        createStake(uint256(100));
        Assert.equal(stakeOf(stakeholders[0]), uint256(100), "Create stake is returned correctly by stakeOf");
    }

    function checkTotalStake () public {
        createStake(uint256(100));
        Assert.equal(totalStake(), uint256(200), "Created stake is returned correctly by totalStake");
    }

    function checkDistributeReward () public {
        distributeReward();
        Assert.equal(totalReward(), uint256(2), "Distribute Reward is returned correctly by totalReward");
    }
}

