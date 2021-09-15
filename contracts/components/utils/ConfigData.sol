//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

contract ConfigData {
    struct BoardConfig {
        uint256 sideLen;
        uint256 minPlayers;
        uint256 maxPlayers;
        bool isPublic;
        uint256 requiredStakeInWei;
    }
    struct PawnConfig {
        uint256 startingHealth;
        uint256 startingPoints;
    }
    struct IntervalConfig {
        uint256 interval;
        uint256 joinableForBlocks;
        uint256 startDeadlineBlocks;
    }
    uint256 gameId;
    address gameCreator;

    BoardConfig public boardConfig;
    PawnConfig public pawnConfig;
    IntervalConfig public intervalConfig;

    modifier onlyGameCreator() {
        require(msg.sender == gameCreator);
        _;
    }
}
