pragma solidity ^0.8.0;

contract Fatigue {
   mapping(address => uint256) public fatigue;
   mapping(address => uint256) public foods;
   mapping(address => uint256) public lastTimestamp;

   address public owner;

   constructor() {
    owner = msg.sender;
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
}