// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract StakeToken is ERC20, Ownable {
    using SafeMath for uint256;
    
    address[] internal stakeholders;
    
    constructor(string memory name, string memory symbol, address _owner, uint256 _supply) ERC20(name, symbol) {
        _mint(_owner, _supply);
    }
    
    function isStakeholder(address _address) public view returns (bool, uint256) {
        for(uint256 i = 0;i < stakeholders.length;i += 1) {
            if (stakeholders[i] == _address) return(true, i);
        }
        return (false, 0);
    }
    
    function addStakeholder(address _address) public {
        (bool _isStakeholder,) = isStakeholder(_address);
        if (!_isStakeholder) stakeholders.push(_address);
    }
    
    function removeStakeholder(address _address) public {
        (bool _isStakeholder, uint256 index) = isStakeholder(_address);
        if (!_isStakeholder) {
            stakeholders[index] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }
    
    mapping (address => uint256) internal stakes;
    
    function stakeOf(address _address) public view returns (uint256) {
        return stakes[_address];
    }
    
    function totalStake() public view returns(uint256) {
        uint256 _totalStakes = 0;
        for(uint index = 0;index < stakeholders.length;index += 1) {
            _totalStakes.add(stakes[stakeholders[index]]);
        }
        return _totalStakes;
    }
    
    function createStake(uint256 _stake) public {
        _burn(msg.sender, _stake);
        if (stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender].add(_stake);
    }

    function removeStake(uint256 _stake) public {
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        if (stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }
    
    mapping (address => uint256) internal rewards;
    
    function rewardOf(address _address) public view returns (uint256) {
        return rewards[_address];
    }
    
    function totalReward() public view returns(uint256) {
        uint256 _totalRewards = 0;
        for(uint index = 0;index < stakeholders.length;index += 1) {
            _totalRewards.add(rewards[stakeholders[index]]);
        }
        return _totalRewards;
    }
    
    function calculateReward(address _stakeHolder) public view returns (uint256) {
        return stakes[_stakeHolder] / 100;
    }
    
    function distributeReward() public  {
        for(uint index = 0;index < stakeholders.length;index += 1) {
            address stakeholder = stakeholders[index];
            rewards[stakeholder] = rewards[stakeholder].add(calculateReward(stakeholder));
        }
    }
    
    function withdrawReward(address _stakeHolder) public {
        uint256 reward = rewards[_stakeHolder];
        rewards[_stakeHolder] = 0;
        _mint(msg.sender, reward);
    }
    
}
