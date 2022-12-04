//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Player.sol";

contract PlayerRegistry {
    // The address of the Player contract
    address public playerContract;

    // The address of the contract owner
    address public owner;

    // The constructor sets the address of the Player contract and sets the owner of the contract to the caller
    constructor(address playerContractAddress) {
        playerContract = playerContractAddress;
        owner = msg.sender;
    }

    // // Function to register a new player or start a new one
    // function registerPlayer() public {
    //     // Create a new Player object in the Player contract and populate its fields with randomized stats
    //     Player player = Player(playerContract);
    //     player.createPlayer(randomValue(), randomValue(), randomValue());
    //     // Add other relevant attributes here
    // }

    // Helper function to generate a random value for a player's stats
    function randomValue() private view returns (uint) {
        // Generate and return a random value between 1 and 100
        return 1 + uint(keccak256(abi.encodePacked(block.difficulty, msg.sender))) % 100;
    }
}
