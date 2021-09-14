//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

contract Players {
    address[] public players;
    // only for non public games
    mapping(address => bool) allowedPlayers;

    function isPlayer(address _a) internal view returns (bool) {
        for (uint256 ii; ii < players.length; ii++) {
            if (players[ii] == _a) {
                return true;
            }
        }
        return false;
    }

    modifier onlyPlayer() {
        require(isPlayer(msg.sender));
        _;
    }
}
