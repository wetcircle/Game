//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Player {
    // Mapping of player addresses to Player objects
    mapping(address => PlayerData) public players;

    // Struct representing a player in the game
    struct PlayerData {
        // The player's health
        uint256 health;
        // The player's strength
        uint256 strength;
        // The player's stamina
        uint256 stamina;
        // The player's player kills
        uint256 playersKilled;
        // The player's mob kills
        uint256 monstersKilled;
    }

    // Function to create a new player
    function createPlayer(
        uint256 health,
        uint256 strength,
        uint256 stamina
    ) public {
        // Create a new PlayerData object and populate its fields
        PlayerData memory newPlayer = PlayerData({
            health: health,
            strength: strength,
            stamina: stamina,
            playersKilled: 0,
            monstersKilled: 0
            // Add other relevant attributes here
        });

        // Save the player to the mapping of players
        players[msg.sender] = newPlayer;
    }

    // Function to update a player's stats
    function updatePlayer(
        address player,
        uint256 health,
        uint256 strength,
        uint256 stamina
    ) public {
        // Retrieve the player from the mapping of players
        PlayerData memory playerData = players[player];

        // Update the player's stats
        playerData.health = health;
        playerData.strength = strength;
        playerData.stamina = stamina;

        // Save the updated player to the mapping of players
        players[player] = playerData;
    }
    
    // Function to update a player's stats
    function setPlayerData(address playerAddress, Player.PlayerData memory playerData) public {
        players[playerAddress] = playerData;
    }


    function getPlayerData(address playerAddress)
        public
        view
        returns (PlayerData memory)
    {
        return players[playerAddress];
    }

    function calculateDamage(PlayerData memory playerData)
        public
        pure
        returns (uint256)
    {
        // Calculate the base damage using the player's strength and stamina
        uint256 baseDamage = (playerData.strength + playerData.stamina) / 2;

        // Calculate the damage multiplier based on the player's mob kills
        uint256 multiplier = 1 + playerData.monstersKilled / 100;

        // Return the final damage calculation
        return baseDamage * multiplier;
    }

}
