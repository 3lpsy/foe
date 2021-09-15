//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "./Game.sol";

contract ScoreBoard {
    uint256[] public activeGames;
    mapping(uint256 => Game) public games;
    mapping(address => uint256[]) public createdGames;

    constructor() {}

    function createGame() external {
        // require(gameCreator == address(0));
        Game _addr = new Game();
        uint256 _id = activeGames.length;
        games[_id] = _addr;
        activeGames[_id] = _id;
        uint256[] storage _createdGames = createdGames[msg.sender];
        _createdGames.push(_id);
    }
}
