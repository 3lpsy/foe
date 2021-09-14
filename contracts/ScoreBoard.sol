//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "./Game.sol";

contract ScoreBoard {
    uint256[] public activeGames;
    mapping(uint256 => Game) public games;
    mapping(address => uint256[]) public createdGames;

    constructor() {}

    function createGame(Game.Config memory _config) external {
        require(_config.gameCreator == address(0));
        Game _addr = new Game();
        uint256 _id = activeGames.length;
        console.log("Configuring..");
        _addr.configure(_config, msg.sender, _id);
        console.log("Post Configure..");

        games[_id] = _addr;
        activeGames[_id] = _id;
        uint256[] storage _createdGames = createdGames[msg.sender];
        _createdGames.push(_id);
    }
}
