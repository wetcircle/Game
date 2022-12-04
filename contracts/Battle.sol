//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Player.sol";

contract Battle {
    Player playerContract;

    // Struct representing a battle request
    struct Request {
        // The address of the player who sent the request
        address sender;
        // The address of the player who is being requested to battle
        address receiver;
        // The timestamp when the request was sent
        uint256 timestamp;
        // The status of the request (0 = pending, 1 = accepted, 2 = rejected)
        uint8 status;
    }

    // Mapping of battle request IDs to Request objects
    mapping(uint256 => Request) public requests;

    // Counter to generate unique request IDs
    uint256 private requestCounter;

    constructor(address playerContractAddress) {
        playerContract = Player(playerContractAddress);
    }

    // Function to request a battle with another player
    function requestBattle(address receiver) public {
        // Create a new Request object and populate its fields
        Request memory newRequest = Request({
            sender: msg.sender,
            receiver: receiver,
            timestamp: block.timestamp,
            status: 0 // Pending
        });

        // Save the request to the mapping of requests and increment the request counter
        requests[requestCounter++] = newRequest;
    }

    // Function to accept a battle request
    function acceptBattle(uint256 requestId) public {
        // Retrieve the request from the mapping of requests
        Request memory request = requests[requestId];

        // Ensure that the request has not been accepted or rejected already
        require(
            request.status == 0,
            "Request has already been accepted or rejected"
        );

        // Ensure that the request is addressed to the msg.sender
        require(
            request.receiver == msg.sender,
            "Request is not addressed to this player"
        );

        // Update the request to indicate that it has been accepted
        request.status = 1;
        requests[requestId] = request;

        // Trigger a call to the battle function
        battle(request.sender, request.receiver);
    }

    function battle(address player1, address player2) public {
        // Import the Player contract and retrieve the player data for each player
        Player player = Player(playerContract);
        Player.PlayerData memory player1Data = player.getPlayerData(player1);
        Player.PlayerData memory player2Data = player.getPlayerData(player2);

        // Calculate the damage dealt by each player
        uint256 player1Damage = player.calculateDamage(player1Data);
        uint256 player2Damage = player.calculateDamage(player2Data);

        // Update the health of each player based on the damage they received
        player1Data.health = safeSub(player1Data.health, player2Damage);
        player2Data.health = safeSub(player2Data.health, player1Damage);

        // Update the player stats in the players mapping
        player.setPlayerData(player1, player1Data);
        player.setPlayerData(player2, player2Data);

        // Check who won the battle and update their stats accordingly
        if (player1Data.health > player2Data.health) {
            player1Data.playersKilled++;
            player.setPlayerData(player1, player1Data);
        } else if (player2Data.health > player1Data.health) {
            player2Data.playersKilled++;
            player.setPlayerData(player2, player2Data);
        }
    }

    // Function to matchmake players and trigger battles
    function matchmaking() public {
        // Retrieve the timestamp of the latest pending request
        uint256 latestTimestamp;
        for (uint256 i = 0; i < requestCounter; i++) {
            if (
                requests[i].status == 0 &&
                requests[i].timestamp > latestTimestamp
            ) {
                latestTimestamp = requests[i].timestamp;
            }
        }

        // If there are pending requests, trigger battles
        if (latestTimestamp > 0) {
            for (uint256 i = 0; i < requestCounter; i++) {
                if (
                    requests[i].status == 0 &&
                    requests[i].timestamp == latestTimestamp
                ) {
                    battle(requests[i].sender, requests[i].receiver);
                }
            }
        }
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
