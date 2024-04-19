// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VRGDA/LinearVRGDA.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {wadLn} from "solmate/utils/SignedWadMath.sol";
import {toTimeUnitWadUnsafe} from "./VRGDA/wadMath.sol";

contract Minter is ReentrancyGuard, LinearVRGDA {

    address public paymentAsset;
    address public mintingAsset;
    uint256 public targetPrice;
    uint256 public priceDecayPercent;
    uint256 public perTimeUnit;
    uint256 public secondsPerTimeUnit;
    address public owner;
    address public geldToken;

    constructor(address _mintingAsset, address _paymentAsset, address _geldToken) {
        owner = msg.sender;
        paymentAsset = _paymentAsset;
        mintingAsset = _mintingAsset;
        geldToken = _geldToken;
    }

    /**
     * @notice Gets the current asset price based on the VRGDA contract
     * @dev The price will depend on the start time, target price and decay constant
     * @param configId ID of the mint configuration to use
     */
    function getPrice() public view returns (uint256) {
        unchecked {
            return
                getVRGDAPrice(
                    toTimeUnitWadUnsafe(block.timestamp - startTimestamp, secondsPerTimeUnit),
                    totalMintedPacks,
                    targetPrice,
                    priceDecayPercent,
                    perTimeUnit
                );
        }
    }

        /**
     * @notice Updates the VRGDA config for a specific mint configuration, will require the mint config to not have an eth payment token (0 address)
     * @dev Only callable by the admin
     * @param mintConfigId The ID of the mint configuration to update
     * @param targetPrice The target price for a pack if sold on pace, scaled by the token decimals, e.g 1e18 for 1 ether, 1e6 for 1 usdc
     * @param priceDecayPercent The percent price decays per unit of time with no sales, scaled by 1e18, e.g 3e17 for 30%
     * @param perTimeUnit The targeted number of packs to sell in 1 full unit of time, scaled by 1e18, e.g 1e18 for 1 pack
     * @param secondsPerTimeUnit The total number of seconds in a time unit. 60 for a minute, 3600 for an hour, 86400 for a day.
     */
    function setVRGDAForMintConfig(
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _perTimeUnit,
        int256 _secondsPerTimeUnit
    ) public {
        require(msg.sender == owner);
        require(_targetPrice > 0, "Non zero target price");
        require(_secondsPerTimeUnit > 0, "Non zero seconds per time unit");
        int256 decayConstant = wadLn(1e18 - _priceDecayPercent);

        // The decay constant must be negative for VRGDAs to work.
        require(decayConstant < 0, "NON_NEGATIVE_DECAY_CONSTANT");


        targetPrice = _targetPrice;
        priceDecayPercent = _priceDecayPercent;
        perTimeUnit = _perTimeUnit;
        secondsPerTimeUnit = _secondsPerTimeUnit;
    }


    function mint() public {
        uint256 currentPrice = getPrice();
        require(IERC20(paymentAsset).transferFrom(msg.sender, address(this), currentPrice));
        IERC20(mintingAsset).mint(msg.sender, 1e18);
        IERC20(paymentAsset).transfer(geldToken, IERC20(paymentAsset).balanceOf(address(this)) / 2);
        IERC20(paymentAsset).transfer(address(0x000000000000000000000000000000000000dEaD), IERC20(paymentAsset).balanceOf(address(this)));
    }
}