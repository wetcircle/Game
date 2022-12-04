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
    uint256 public requestCounter;

    constructor(address playerContractAddress) {
        playerContract = Player(playerContractAddress);
    }

    // Function to request a battle with another player
    function requestBattle(address sender, address receiver) public {
        // Create a new Request object and populate its fields
        Request memory newRequest = Request({
            sender: sender,
            receiver: receiver,
            timestamp: block.timestamp,
            status: 0 // Pending
        });

        // Save the request to the mapping of requests and increment the request counter
        requests[requestCounter++] = newRequest;
    }

    function acceptBattle(uint256 requestId, address sender) public {
        // Retrieve the request from the mapping of requests
        Request memory request = requests[requestId];

        // Ensure that the sender is the receiver of the request
        require(
            request.receiver == sender,
            "Only the receiver of the request can accept it."
        );

        // Update the request status to accepted
        request.status = 1;

        // Save the updated request to the mapping of requests
        requests[requestId] = request;
    }

function battle(address player1, address player2) public {

    // Retrieve player contract
    Player player = Player(playerContract);

    // Update the health of each player and their stats
    player.calculateAndUpdateDamage(player1, player2);

    // Retrieve player stats
    Player.PlayerData memory player1Data = player.getPlayerData(player1);
    Player.PlayerData memory player2Data = player.getPlayerData(player2);

    // Check who won the battle and update their stats accordingly
    if (player1Data.health > player2Data.health) {
        player1Data.battlesWon++;
        player.setPlayerData(player1, player1Data);
    } else if (player2Data.health > player1Data.health) {
        player2Data.battlesWon++;
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

}
