pragma solidity ^0.8.0;

contract Fatigue {
   mapping(address => uint256) public fatigue;
   mapping(address => uint256) public foods;
   mapping(address => uint256) public lastTimestamp;

   address public owner;
   address public sabatogeAddress;

   constructor(address _sab) {
    owner = msg.sender;
    sabatogeAddress = _sab;
   }


    function returnFatigue(address _player) public view returns(uint256) {
        if(block.timestamp - lastTimestamp[_player] > fatigue[_player]){
            return 0;
        } else {
            return (fatigue[_player] - (block.timestamp - lastTimestamp[_player]));
        }
        
    }

    function eat(address _food) public {
        require(foods[_food] > 0);
        fatigue[msg.sender] = foods[_food];
        lastTimestamp[msg.sender] = block.timestamp;
    }

    function setFood(address _food, uint256 _fatigue) public {
        require(msg.sender == owner);
        foods[_food] = _fatigue;
    }

    function fixFatigue(address _player, uint256 _fatigue) public {
        require(msg.sender == owner);
        fatigue[_player] = _fatigue;
    }

    function sabatoge(address _player, uint256 _amount) public {
        require(msg.sender == sabatogeAddress);
        if(_amount >= fatigue[_player]){
            fatigue[_player] = 0;
        } else {
            fatigue[_player] -= _amount;
        }
    }

    function setSabatogeAddress(address _sab) public {
        require(msg.sender == owner);
        sabatogeAddress = _sab;
    }
}