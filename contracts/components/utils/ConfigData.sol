//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

contract ConfigData {
    struct Config {
        uint256 id;
        uint256 xLen;
        uint256 yLen;
        uint256 minPlayers;
        uint256 maxPlayers;
        uint256 interval;
        uint256 joinableForBlocks;
        uint256 startDeadlineBlocks;
        uint256 requiredStakeInWei;
        uint256 startingHealth;
        uint256 startingPoints;
        address gameCreator;
        bool isPublic;
    }
    Config public config;
    modifier onlyGameCreator() {
        require(msg.sender == config.gameCreator);
        _;
    }
}
