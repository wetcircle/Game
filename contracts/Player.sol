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
        // The player's pvp wins
        uint256 battlesWon;
        // The player's player kills
        uint256 playersKilled;
    }

    // Function to create a new player
    function createPlayer(
        address player,
        uint256 health,
        uint256 strength,
        uint256 stamina
    ) public {
        // Create a new PlayerData object and populate its fields
        PlayerData memory newPlayer = PlayerData({
            health: health,
            strength: strength,
            stamina: stamina,
            battlesWon: 0,
            playersKilled: 0
            // Add other relevant attributes here
        });

        // Save the player to the mapping of players
        players[player] = newPlayer;
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
    function setPlayerData(
        address playerAddress,
        Player.PlayerData memory playerData
    ) public {
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
        uint256 multiplier = 1 + playerData.playersKilled / 100;

        // Return the final damage calculation
        return baseDamage * multiplier;
    }

    /** * 
     * @dev Calculates and updates the damage dealt to and received by two players in a battle.
     *
     * @param player1 The address of the first player involved in the battle.
     * @param player2 The address of the second player involved in the battle.
     */
    function calculateAndUpdateDamage(address player1, address player2) public {

        // Retrieve the player data for each player
        PlayerData memory player1Data = getPlayerData(player1);
        PlayerData memory player2Data = getPlayerData(player2);

        // Calculate the damage dealt by each player
        uint256 player1Damage = calculateDamage(player1Data);
        uint256 player2Damage = calculateDamage(player2Data);

        // Update the health of each player based on the damage they received
        player1Data.health = safeSub(player1Data.health, player2Damage);
        player2Data.health = safeSub(player2Data.health, player1Damage);

        // Update the player stats in the players mapping
        setPlayerData(player1, player1Data);
        setPlayerData(player2, player2Data);
    }

    function calculateDamage(address playerAddress)
        public
        view
        returns (uint256)
    {
        PlayerData memory playerData = players[playerAddress];

        // Calculate the base damage using the player's strength and stamina
        uint256 baseDamage = (playerData.strength + playerData.stamina) / 2;

        // Calculate the damage multiplier based on the player's pvp kills
        uint256 multiplier = 1 + playerData.playersKilled / 100;

        // Return the final damage calculation
        return baseDamage * multiplier;
    }

    function safeSub(uint256 x, uint256 y) public pure returns (uint256) {
        // Check if x is greater than or equal to y
        if (x >= y) {
            // If x is greater than or equal to y, return the result of x - y
            return x - y;
        } else {
            // If x is less than y, return 0 to prevent underflow
            return 0;
        }
    }
}
