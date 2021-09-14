//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

contract Statable {
    enum State {
        Unconfigured,
        WaitingForGameCreator,
        Open,
        WaitingForCoordReveal,
        AcceptingActions,
        ConfirmingActions,
        AwaitingTick,
        Finished
    }

    State public state;

    function isState(State _state) internal view returns (bool) {
        return _state == state;
    }

    modifier onlyState(State _state) {
        require(isState(_state));
        _;
    }

    function changeState(State _state) internal {
        state = _state;
    }
}
