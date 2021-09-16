//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

contract Actionable {
    enum ActionType {
        Unconfirmed,
        Move,
        Shoot,
        Noop
    }

    struct Action {
        uint256 personalPawnId;
        uint256 moveCoord;
        uint256 shootTarget;
        ActionType actionType;
    }

    function decodeAction(bytes32 _action) public pure returns (Action memory) {
        Action memory _decodedAction;
        return _decodedAction;
    }
}
