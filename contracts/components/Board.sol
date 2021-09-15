//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;
import "./utils/Ownable.sol";
import "./utils/Statable.sol";
import "./utils/Players.sol";
import "./utils/ConfigData.sol";
import "./utils/Constants.sol";

contract Board is Constants, ConfigData, Players {
    struct Pawn {
        uint256 coord;
        uint256 health;
        uint256 points;
    }
    mapping(address => Pawn[3]) board;

    modifier onlyAlive() {
        require(isAlive(msg.sender));
        _;
    }

    function isPawnAlive(Pawn memory _pawn) public pure returns (bool) {
        return _pawn.health > 0;
    }

    function isPawnAliveByDat(address _player, uint256 _id)
        public
        view
        returns (bool)
    {
        Pawn[3] storage _pawns = board[_player];
        Pawn memory _pawn = _pawns[_id];
        return isPawnAlive(_pawn);
    }

    function isAlive(address _a) internal view returns (bool) {
        require(isPlayer(_a));
        Pawn[3] storage _pawns = board[_a];
        for (uint256 ii; ii < _pawns.length; ii++) {
            Pawn memory _pawn = _pawns[ii];
            if (!isPawnAlive(_pawn)) {
                return false;
            }
        }
        return true;
    }

    function countAlivePlayers() public view returns (uint256) {
        uint256 count;
        for (uint256 ii; ii < players.length; ii++) {
            if (isAlive(players[ii])) {
                count++;
            }
        }
        return count;
    }

    function getAlivePlayers() public view returns (address[] memory) {
        uint256 _count = 0;
        address[] memory _players = new address[](countAlivePlayers());
        for (uint256 ii; ii < players.length; ii++) {
            if (isAlive(players[ii])) {
                _players[ii] = players[ii];
                _count++;
            }
        }
        return _players;
    }

    function isWithinMoveRange(uint256 _coord, uint256 _target)
        internal
        view
        returns (bool)
    {
        return isWithinRange(_coord, _target, MOVE_RANGE);
    }

    function isWithinRange(
        uint256 _coord,
        uint256 _target,
        uint256 _maxRange
    ) internal view returns (bool) {
        // column
        uint256 _currentX = _coord % boardConfig.sideLen;
        // row
        uint256 _currentY = _coord / boardConfig.sideLen;
        uint256 _targetX = _target % boardConfig.sideLen;
        uint256 _targetY = _target / boardConfig.sideLen;

        uint256 _diffX;
        uint256 _diffY;
        // you can't make me do math
        if (_currentX > _targetX) {
            _diffX = _currentX - _targetX;
        } else {
            _diffX = _targetX - _currentX;
        }

        if (_diffX > _maxRange) {
            return false;
        }
        if (_currentY > _targetY) {
            _diffY = _currentY - _targetY;
        } else {
            _diffY = _targetY - _currentY;
        }
        if (_diffY > _maxRange) {
            return false;
        }
        return true;
    }

    function doPawnReceiveHit(address _player, uint256 _id) internal {
        Pawn storage _pawn = board[_player][_id];
        _pawn.health = _pawn.health - 1;
    }

    function isCoordTaken(uint256 _coord) public view returns (bool) {
        for (uint256 ii; ii < players.length; ii++) {
            Pawn[3] memory _pawns = board[players[ii]];
            for (uint256 jj; jj < _pawns.length; jj++) {
                Pawn memory _pawn = _pawns[jj];
                if (_pawn.coord == _coord) {
                    return true;
                }
            }
        }
        return false;
    }

    function isCoordTakenByAlivePawn(uint256 _coord)
        public
        view
        returns (bool)
    {
        for (uint256 ii; ii < players.length; ii++) {
            Pawn[3] memory _pawns = board[players[ii]];
            for (uint256 jj; jj < _pawns.length; jj++) {
                Pawn memory _pawn = _pawns[jj];
                if (_pawn.coord == _coord && _pawn.health > 0) {
                    return true;
                }
            }
        }
        return false;
    }

    function _getNearestAvailCoord(uint256 _coord)
        internal
        view
        returns (uint256, bool)
    {
        uint256 _newCoord = _coord;
        uint256 _count = 1;
        bool _changed = false;
        while (
            (_newCoord + _count) <= (boardConfig.sideLen * boardConfig.sideLen)
        ) {
            _newCoord = _newCoord + _count;
            if (!isCoordTaken(_newCoord)) {
                _coord = _newCoord;
                _changed = true;
                break;
            }
            _count++;
        }
        if (!_changed) {
            _newCoord = _coord;
            _count = 1;
            while ((_newCoord - _coord) > 0) {
                _newCoord = _newCoord - _count;
                if (!isCoordTaken(_newCoord)) {
                    _coord = _newCoord;
                    _changed = true;
                    break;
                }
                _count++;
            }
        }
        return (_coord, _changed);
    }
}
