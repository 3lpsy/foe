//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;
import "./utils/Statable.sol";
import "./utils/Actionable.sol";
import "./utils/Ownable.sol";
import "./utils/Constants.sol";
import "./utils/ConfigData.sol";
import "./utils/Players.sol";

import "./Board.sol";

contract RunningState is
    Constants,
    Actionable,
    Statable,
    Ownable,
    ConfigData,
    Players,
    Board
{
    uint256 public startBlock;
    uint256 public round = 0;
    address public requiredToTick;

    mapping(address => bytes32[3]) requestedStartingCoords;
    mapping(address => bool) confirmedStartingCoords;
    mapping(address => bytes32) submittedRoundActions;
    mapping(address => bytes32) confirmedRoundActions;

    modifier onlyTicker() {
        require(msg.sender == requiredToTick);
        _;
    }

    function commit(bytes32 _actionHash)
        external
        onlyAlive
        onlyState(State.AcceptingActions)
    {
        submittedRoundActions[msg.sender] = _actionHash;
    }

    function reveal(
        bytes32 _secret,
        ActionType _actionType,
        bytes32 _action
    ) external onlyAlive onlyState(State.ConfirmingActions) {
        require(
            _verifyAction(_secret, _actionType, _action),
            "Invalid action submitted"
        );
    }

    function tick() external onlyPlayer onlyState(State.AwaitingTick) {
        // check if called by non ticker and outside required tick parameters
        // kill ticker if so and make caller new ticker and return early
        // loop over each confirmed action
        // check if there exists bytes there
        // perform each action
        // move:
        // check if pawn is alive
        // check if target spot is in bounds
        // check if empty
        // move
        // attac:
        // check if pawn is alive
        // check if target within reach
        // attack
        // distribute points
        // clear submit/reveal data and change state
    }

    function closeGameToNewUsers() external onlyState(State.Open) onlyPlayer {
        if (block.number > (startBlock + config.startDeadlineBlocks)) {
            changeState(State.WaitingForCoordReveal);
        } else {
            require(
                block.number > (config.joinableForBlocks + startBlock),
                "Cannot close game to new players yet."
            );
            for (uint256 ii; ii < players.length; ii++) {
                require(
                    confirmedStartingCoords[players[ii]],
                    "Not all players have confirmed their starting coords"
                );
            }
            changeState(State.WaitingForCoordReveal);
        }
    }

    function start()
        external
        onlyPlayer
        onlyState(State.WaitingForCoordReveal)
    {
        changeState(State.AcceptingActions);
    }

    function addPlayersToAllowList(address[] calldata _players)
        external
        onlyGameCreator
    {
        for (uint256 ii; ii < _players.length; ii++) {
            allowedPlayers[_players[ii]] = true;
        }
    }

    function addPlayerToAllowList(address _player) public onlyGameCreator {
        allowedPlayers[_player] = true;
    }

    function joinGame(bytes32[3] calldata _requestedStartingCoords)
        external
        payable
    {
        require(
            msg.value >= config.requiredStakeInWei,
            "Insufficient stake amount"
        );
        if (!config.isPublic) {
            require(
                allowedPlayers[msg.sender] == true,
                "Not authorized to join game"
            );
        }
        if (state == State.WaitingForGameCreator) {
            require(msg.sender == config.gameCreator);
        }
        _addPlayer(msg.sender);
        requestedStartingCoords[msg.sender] = _requestedStartingCoords;
    }

    function confirmStartingCoords(bytes32 _secret, uint256[3] calldata _coords)
        external
        onlyState(State.WaitingForCoordReveal)
        onlyPlayer
    {
        uint256 _newCoordCount = 0;
        for (uint256 ii; ii < _coords.length; ii++) {
            require(
                _verifyCoords(_secret, _coords[ii]),
                "Unable to verify one of starting coordinates"
            );
            uint256 _coord = _coords[ii];
            if (_coord > 0 && _coord <= (config.xLen * config.yLen)) {
                // they messed up
                continue;
            } else {
                // TODO: this is super busted
                if (isCoordTaken(_coord)) {
                    bool _found;
                    (_coord, _found) = _getNearestAvailCoord(_coord);
                }
                Pawn memory _newPawn = Pawn(
                    _coord,
                    config.startingPoints,
                    config.startingHealth
                );
                board[msg.sender][_newCoordCount] = _newPawn;
                _newCoordCount++;
            }
        }
        confirmedStartingCoords[msg.sender] = true;
    }

    function _verifyAction(
        bytes32 _secret,
        ActionType _actionType,
        bytes32 _action
    ) internal returns (bool) {
        return true;
    }

    function _verifyCoords(bytes32 _secret, uint256 coords)
        internal
        returns (bool)
    {
        return true;
    }

    function _addPlayer(address _player) internal {
        require(isState(State.Open) || isState(State.WaitingForGameCreator));
        if (players.length == 0) {
            requiredToTick = _player;
            changeState(State.Open);
        }
        players[players.length - 1] = _player;
    }
}
