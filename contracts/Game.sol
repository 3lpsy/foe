//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

import "./components/Configurable.sol";
import "./components/RunningState.sol";

contract Game is Configurable, RunningState {
    constructor() {
        owner = msg.sender;
        round = 0;
        startBlock = block.number;
        state = State.Unconfigured;
    }
}
