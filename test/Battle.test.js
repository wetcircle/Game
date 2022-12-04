const { expect } = require("chai");

describe("Battle", () => {
  let player;
  let battle;

  beforeEach(async () => {
    // Deploy the Player contract
    const Player = await ethers.getContractFactory("Player");
    player = await Player.deploy();

    // Deploy the Battle contract and pass in the address of the Player contract
    const Battle = await ethers.getContractFactory("Battle");
    battle = await Battle.deploy(player.address);
  });

  it("should create a new battle request", async () => {
    // Get the address of the person calling the function
    const signers = await ethers.getSigners();
    const senderAddress = await signers[0].getAddress();
    const receiverAddress = await signers[1].getAddress();

    // Create two new players
    await player.createPlayer(senderAddress, 100, 50, 50);
    await player.createPlayer(receiverAddress, 100, 50, 50);

    // Request a battle with the new player
    await battle.requestBattle(senderAddress, receiverAddress);

    // Get the latest battle request
    const requestId = (await battle.requestCounter()).sub(1);
    const request = await battle.requests(requestId);

    // Verify that the request has been created correctly
    expect(request.sender).to.equal(senderAddress);
    expect(request.receiver).to.equal(receiverAddress);
    expect(request.status).to.equal(0); // Pending
  });

  it("should accept a battle request", async () => {
    // Get the addresses of the two players
    const signers = await ethers.getSigners();
    const senderAddress = await signers[0].getAddress();
    const receiverAddress = await signers[1].getAddress();

    // Create two new players
    await player.createPlayer(senderAddress, 100, 50, 50);
    await player.createPlayer(receiverAddress, 100, 50, 50);

    // Player 1 requests a battle with player 2
    await battle.requestBattle(senderAddress, receiverAddress);

    // Get the latest battle request
    const requestId = (await battle.requestCounter()).sub(1);

    // Player 2 accepts the battle request
    await battle.acceptBattle(requestId, receiverAddress);

    // Get the updated battle request
    const request = await battle.requests(requestId);

    // Verify that the request has been accepted
    expect(request.status).to.equal(1); // Accepted
  });

  it("should simulate a battle between two players", async () => {
    // Get the addresses of the two players
    const signers = await ethers.getSigners();

    const player1Address = await signers[0].getAddress();
    const player2Address = await signers[1].getAddress();

    // Dependant variable
    const STARTING_HEALTH = 100;

    // Create two new players
    await player.createPlayer(player1Address, STARTING_HEALTH, 50, 50);
    await player.createPlayer(player2Address, STARTING_HEALTH, 50, 50);

    // Simulate a battle between the two players
    await battle.battle(player1Address, player2Address);

    // Get the updated player data for each player
    const player1Data = await player.getPlayerData(player1Address);
    const player2Data = await player.getPlayerData(player2Address);

    // Get winner
    let winner;
    let loser;
    if (player1Data.health > player2Data.health) {
      (winner = player1Data), (loser = player2Data);
    } else {
      (winner = player2Data), (loser = player1Data);
    }

    // Verify that the players have taken damage and that the correct player won
    expect(player1Data.health).to.be.below(STARTING_HEALTH);
    expect(player2Data.health).to.be.below(STARTING_HEALTH);
    expect(winner.battlesWon).to.equal(1);
    expect(winner.playersKilled).to.equal(1);
    expect(loser.battlesWon).to.equal(0);
    expect(loser.battlesWon).to.equal(0);
  });
});
