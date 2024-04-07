pragma solidity ^0.8.0;

library Math {
    function log(uint256 x) internal pure returns (uint256) {
        if (x < 2) return 0;
        uint256 result = 0;
        while (x >= 2) {
            x >>= 1;
            result++;
        }
        return result;
    }
}

contract LevelingSystem {
    uint256 public constant STARTING_LEVEL = 1;
    uint256 public constant STARTING_EXP = 250; // 250 exp for level 1
    uint256 public constant MAX_LEVEL = 100;
    uint256 public constant MAX_EXP = 10_000_000; // Approximately the exp required for level 100

    function getLevel(uint256 totalExp) public pure returns (uint256) {
        return _getLevel(totalExp);
    }

    function getExpForLevel(uint256 level) public pure returns (uint256) {
        return _getExpForLevel(level);
    }

    function _getLevel(uint256 totalExp) private pure returns (uint256) {
        // Use a polynomial function to calculate the level
        uint256 level = STARTING_LEVEL + uint256(
            (totalExp * 99) / (MAX_EXP - STARTING_EXP)
        );

        // Ensure the level doesn't exceed the max level
        return level > MAX_LEVEL ? MAX_LEVEL : level;
    }

    function _getExpForLevel(uint256 level) private pure returns (uint256) {
        // Use a polynomial function to calculate the experience points required for the given level
        return STARTING_EXP + ((MAX_EXP - STARTING_EXP) * (level - STARTING_LEVEL)) / (MAX_LEVEL - STARTING_LEVEL);
    }
}