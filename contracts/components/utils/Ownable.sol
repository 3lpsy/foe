//SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.8.0;

contract Ownable {
    address owner;
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
