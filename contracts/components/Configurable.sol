//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;
import "./utils/Ownable.sol";
import "./utils/Statable.sol";
import "./utils/Constants.sol";
import "./utils/Players.sol";
import "./utils/ConfigData.sol";

contract Configurable is Constants, Statable, Ownable, ConfigData, Players {
    // should only be called by scoreboard

    function init(uint256 _id, address _gameCreator)
        external
        onlyOwner
        onlyState(State.Unconfigured)
    {
        gameId = _id;
        gameCreator = _gameCreator;
    }

    function configureInterval(IntervalConfig calldata _config)
        external
        onlyOwner
        onlyState(State.Unconfigured)
    {
        require(gameCreator != address(0));
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
        intervalConfig = _config;
    }

    function configurePawn(PawnConfig calldata _config)
        external
        onlyOwner
        onlyState(State.Unconfigured)
    {
        pawnConfig = _config;
    }

    function configureBoard(BoardConfig calldata _config)
        external
        onlyOwner
        onlyState(State.Unconfigured)
    {
        require(intervalConfig.interval > 0);
        require(pawnConfig.startingHealth > 0);

        require(_config.sideLen <= MAX_X && _config.sideLen >= MIN_X);
        require(_config.sideLen <= MAX_Y && _config.sideLen >= MIN_Y);
        require(_config.maxPlayers <= (_config.sideLen * _config.sideLen) / 4);
        boardConfig = _config;

        if (!boardConfig.isPublic) {
            allowedPlayers[gameCreator] = true;
        }
        // board = new address[](_config.sideLen * _config.sideLen);
        changeState(State.WaitingForGameCreator);
    }
}
