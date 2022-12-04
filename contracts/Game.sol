//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Player.sol";
import "./Battle.sol";

contract Game {
    // The address of the Player contract
    address playerContract;

    // The address of the Battle contract
    address battleContract;

    // The address of the contract owner
    address owner;

    // The constructor sets the addresses of the Player and Battle contracts and sets the owner of the contract to the caller
    constructor(address playerContractAddress, address battleContractAddress) {
        playerContract = playerContractAddress;
        battleContract = battleContractAddress;
        owner = msg.sender;
    }

    // Function to register a new player or start a new one
    function registerPlayer() public {
        // Only the contract owner can register new players
        require(msg.sender == owner);

        // Create a new Player object in the Player contract and populate its fields with randomized stats
        Player player = Player(playerContract);
        player.createPlayer(msg.sender, randomValue(), randomValue(), randomValue());
        // Add other relevant attributes here
    }

    // Function to simulate a battle between two players
    function battle(address player1, address player2) public {
        // Only the contract owner can simulate battles
        require(msg.sender == owner);

        // Create a new Battle object in the Battle contract and simulate the battle
        Battle _battle = Battle(battleContract);
        _battle.battle(player1, player2);
    }

    // Helper function to generate a random value for a player's stats
    function randomValue() private view returns (uint) {
        // Generate and return a random value between 1 and 100
        return 1 + uint(keccak256(abi.encodePacked(block.difficulty, msg.sender))) % 100;
    }
}