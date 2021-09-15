describe("Basic Setup", function () {
  beforeEach(async () => {
    // We get the contract to deploy
    const Scoreboard = await hre.ethers.getContractFactory("ScoreBoard");
    const scoreBoard = await Scoreboard.deploy();

    let tx = await scoreBoard.deployed();
    console.log("scoreBoard deployed to:", scoreBoard.address);
  });
  it("Should return the new greeting once it's changed", async function () {});
});
