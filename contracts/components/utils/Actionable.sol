//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

contract Actionable {
    enum ActionType {
        Move,
        Shoot,
        Stay,
        BadAction
    }

    struct Action {
        uint256 personalPawnId;
        uint256 moveCoord;
        address shootTarget;
        ActionType actionType;
    }
}
