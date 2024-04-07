contract miningExp{
    address public owner;

    constructor() {
        owner = msg.sender;
        updaterContracts[msg.sender] = true;
    }

    mapping(address => bool) public updaterContracts;

    mapping(address => uint256) public miningExp;

    function updateMining(address _address, uint256 _add, uint256 _sub) public {
        require(updaterContracts[msg.sender] == true);
        if(_add != 0){
            miningExp[_address] += _add;
        }
        if(_sub != 0) {
            if(_sub <= miningExp[_address]){
                miningExp[_address] -= _sub;
            } else {
                miningExp[_address] = 0;
            }
        }
    }

    function editUpdater(address _address, bool _bool) public {
        require(msg.sender == owner);
        updaterContracts[_address] = _bool;
    }
}