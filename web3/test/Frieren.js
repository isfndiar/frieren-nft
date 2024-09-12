const { ethers } = require("hardhat");
const { expect } = require("chai");
describe("Frieren Contract", function () {
  let Frieren;
  let frieren;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  describe("Deployment", function () {
    beforeEach(async function () {
      Frieren = await ethers.getContractFactory("Frieren");
      [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
      console.log(owner.address);
      frieren = await Frieren.deploy(owner.address);
      await frieren.deployed();
    });

    it("Should set the right owner", async function () {
      expect(await frieren.owner()).to.equal(owner.address);
    });

    it("Should have the correct initial values", async function () {
      expect(await frieren.publicMintOpen()).to.be.false;
      expect(await frieren.allowMintOpen()).to.be.false;
      expect(await frieren.presaleMintOpen()).to.be.false;
      expect(await frieren.MAX_SUPPLY()).to.equal(1000);
    });
  });
});
