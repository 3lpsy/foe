//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;
import "./utils/Ownable.sol";
import "./utils/Statable.sol";
import "./utils/Constants.sol";
import "./utils/Players.sol";
import "./utils/ConfigData.sol";

contract Configurable is Constants, Statable, Ownable, ConfigData, Players {
    // should only be called by scoreboard
    function configure(
        Config memory _config,
        address _gameCreator,
        uint256 _id
    ) external onlyOwner onlyState(State.Unconfigured) {
        require(_config.xLen <= MAX_X && _config.xLen >= MIN_X);
        require(_config.yLen <= MAX_Y && _config.yLen >= MIN_Y);
        require(
            _config.interval <= MAX_BLK_INT && _config.interval >= MIN_BLK_INT
        );
        require(
            _config.joinableForBlocks <= 10000 &&
                _config.joinableForBlocks >= MIN_BLK_INT
        );
        require(
            _config.joinableForBlocks <= 10000 &&
                _config.joinableForBlocks >= MIN_BLK_INT
        );
        require(_config.joinableForBlocks <= _config.startDeadlineBlocks);
        require(
            _config.startDeadlineBlocks <= 10000 &&
                _config.startDeadlineBlocks >= MIN_BLK_INT
        );
        require(_config.maxPlayers <= (_config.xLen * _config.yLen) / 4);
        config = _config;
        config.id = _id;
        config.gameCreator = _gameCreator;
        if (!config.isPublic) {
            allowedPlayers[config.gameCreator] = true;
        }
        // board = new address[](_config.xLen * _config.yLen);
        changeState(State.WaitingForGameCreator);
    }
}
