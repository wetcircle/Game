const { expect } = require("chai");

describe("Player", () => {
  let player;

  // Deploy contract before every test
  beforeEach(async () => {
    const Player = await ethers.getContractFactory("Player");
    player = await Player.deploy();
  });

  it("should create a new player", async () => {
    const signers = await ethers.getSigners();
    const playerAddress = signers[0].getAddress();

    // Initialize new player
    const initialStats = {
      health: 100,
      strength: 50,
      stamina: 50,
    };
    await player.createPlayer(
      playerAddress,
      initialStats.health,
      initialStats.strength,
      initialStats.stamina
    );

    // Check
    const playerData = await player.getPlayerData(playerAddress);
    expect(playerData.health).to.equal(initialStats.health);
    expect(playerData.strength).to.equal(initialStats.strength);
    expect(playerData.stamina).to.equal(initialStats.stamina);
  });

  it("should update a player's stats", async () => {
    const signers = await ethers.getSigners();
    const playerAddress = signers[0].getAddress();

    // Initialize player
    const initialStats = {
      health: 100,
      strength: 50,
      stamina: 50,
    };
    await player.createPlayer(
      playerAddress,
      initialStats.health,
      initialStats.strength,
      initialStats.stamina
    );

    // Update stats
    const updatedStats = {
      health: 150,
      strength: 75,
      stamina: 75,
    };
    await player.updatePlayer(
      playerAddress,
      updatedStats.health,
      updatedStats.strength,
      updatedStats.stamina
    );

    // Check
    const playerData = await player.getPlayerData(playerAddress);
    expect(playerData.health).to.equal(updatedStats.health);
    expect(playerData.strength).to.equal(updatedStats.strength);
    expect(playerData.stamina).to.equal(updatedStats.stamina);
  });

  it("should set a player's data", async () => {
    const signers = await ethers.getSigners();
    const playerAddress = signers[0].getAddress();

    // Initialize player
    const initialStats = {
      health: 100,
      strength: 50,
      stamina: 50,
    };
    await player.createPlayer(
      playerAddress,
      initialStats.health,
      initialStats.strength,
      initialStats.stamina
    );

    // Update stats
    const updatedStats = {
      health: 150,
      strength: 75,
      stamina: 75,
    };
    await player.updatePlayer(
      playerAddress,
      updatedStats.health,
      updatedStats.strength,
      updatedStats.stamina
    );
    // Check
    const savedPlayerData = await player.getPlayerData(playerAddress);
    expect(savedPlayerData.health).to.equal(updatedStats.health);
    expect(savedPlayerData.strength).to.equal(updatedStats.strength);
    expect(savedPlayerData.stamina).to.equal(updatedStats.stamina);
  });
});
