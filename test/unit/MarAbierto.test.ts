import { expect } from "chai";
import { ethers } from "hardhat"
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { MarAbiertoToken__factory, NoNFTReceiver__factory, NFTReceiver__factory } from "../../typechain";

const MINT_PRICE = ethers.utils.parseEther("0.1");

async function MarAbiertoFixture() {
    const [owner, user] = await ethers.getSigners();

    const MarAbiertoTokenFactory = (await ethers.getContractFactory(
        "MarAbiertoToken", owner
    )) as MarAbiertoToken__factory;
    const NFTContract = await MarAbiertoTokenFactory.deploy("test");

    const NoNFtReceiver = (await ethers.getContractFactory(
        "NoNFTReceiver", owner
        )) as NoNFTReceiver__factory;
    const NftReceiver = (await ethers.getContractFactory(
        "NFTReceiver", owner
        )) as NFTReceiver__factory;
    const noNFTReceiver = await NoNFtReceiver.deploy(NFTContract.address, {value: MINT_PRICE});
    const nftReceiver = await NftReceiver.deploy(NFTContract.address, {value: MINT_PRICE});
    return { NFTContract, nftReceiver, noNFTReceiver, owner, user }
}

describe("MarAbierto", function () {

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            expect(await NFTContract.owner()).to.equal(owner.address);
        })
        it("Should set the right name", async function () {
            const { NFTContract } = await loadFixture(MarAbiertoFixture);
            expect(await NFTContract.name()).to.equal("MarAbierto");
        })
        it("Should set the right symbol", async function () {
            const { NFTContract } = await loadFixture(MarAbiertoFixture);
            expect(await NFTContract.symbol()).to.equal("MAR");
        })
        it("Should set the right baseURI", async function () {
            const { NFTContract } = await loadFixture(MarAbiertoFixture);
            expect(await NFTContract.getBaseURI()).to.equal("test");
        })
    })

    describe("SetBaseURI", function () {
        it("Should set the right baseURI", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).setBaseURI("test2");
            expect(await NFTContract.getBaseURI()).to.equal("test2");
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).setBaseURI("test2")).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("AddSupply", function () {
        it("Should add supply", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            const supply = await NFTContract.getSupply();
            await NFTContract.connect(owner).addSupply(1);
            expect(await NFTContract.getSupply()).to.equal(supply.add(1));
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).addSupply(1)).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("SetMintPrice", function () {
        it("Should set mint price", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).setMintPrice(1);
            expect(await NFTContract.getPrice()).to.equal(1);
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).setMintPrice(1)).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("Mint", function () {
        it("Should mint", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).mint(owner.address, {value: MINT_PRICE});
            expect(await NFTContract.balanceOf(owner.address)).to.equal(1);
        })
        it("Should revert if not enough value", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(owner).mint(owner.address, {value: MINT_PRICE.sub(1)})).to.be.revertedWithCustomError(NFTContract, "MarAbiertoToken__InsufficientETHAmount");
        })
        it("Should revert if not enough supply", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            const supply = (await NFTContract.getSupply());
            for (let i = 0; i < Number(supply); i++) {
                await NFTContract.connect(owner).mint(owner.address, {value: MINT_PRICE});
            }
            await expect(NFTContract.connect(owner).mint(owner.address, {value: MINT_PRICE})).to.be.revertedWithCustomError(NFTContract, "MarAbiertoToken__AllTokensAreMinted");
        })
        it("Should increase tokenId counter", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.mint(owner.address, {value: MINT_PRICE});
            expect(Number(await ethers.provider.getStorageAt(NFTContract.address, 7))).to.equal(1);
        })
        it("Reverts if contract calling doesn't implement onERC721Received", async function () {
            const { NFTContract, nftReceiver, noNFTReceiver } = await loadFixture(MarAbiertoFixture);
            await expect(noNFTReceiver.mint()).to.be.revertedWithCustomError(noNFTReceiver, "NoNFTReceiver__MintFailed");
            await expect(nftReceiver.mint()).to.not.be.reverted;
            expect(await NFTContract.balanceOf(nftReceiver.address)).to.equal(1);
        })
    })

    describe("MintAmount", function () {
        it("Should mint amount", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.mintAmount(2, {value: MINT_PRICE.mul(2)})).to.not.be.reverted;
            await expect(await NFTContract.balanceOf(owner.address)).to.equal(2);
        })
        it("Should revert if not enough value", async function () {
            const { NFTContract } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.mintAmount(2, {value: MINT_PRICE.mul(2).sub(1)})).to.be.revertedWithCustomError(NFTContract, "MarAbiertoToken__InsufficientETHAmount");
        })
    })

    describe("MintOwner", function () {
        it("Should mint to owner", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).mintOwner(owner.address);
            await expect(await NFTContract.balanceOf(owner.address)).to.equal(1);
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user} = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).mintOwner(user.address)).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("MintAmountOwner", function () {
        it("Should mint amount to owner", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).mintAmountOwner(2);
            await expect(await NFTContract.balanceOf(owner.address)).to.equal(2);
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).mintAmountOwner(2)).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("Withdraw", function () {
        it("Should withdraw", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).mint(owner.address, {value: MINT_PRICE});
            await NFTContract.connect(owner).withdraw();
            await expect(await ethers.provider.getBalance(NFTContract.address)).to.equal(0);
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).withdraw()).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("Pause", function () {
        it("Should pause", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).pause();
            await expect(await NFTContract.paused()).to.equal(true);
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).pause()).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("Unpause", function () {
        it("Should unpause", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).pause();
            await NFTContract.connect(owner).unpause();
            await expect(await NFTContract.paused()).to.equal(false);
        })
        it("Should revert if not owner", async function () {
            const { NFTContract, user } = await loadFixture(MarAbiertoFixture);
            await expect(NFTContract.connect(user).unpause()).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("BeforeTokenTransfer", function () {
        it("Should revert if paused", async function () {
            const { NFTContract, owner } = await loadFixture(MarAbiertoFixture);
            await NFTContract.connect(owner).pause();
            await expect(NFTContract.mint(owner.address, {value: MINT_PRICE})).to.be.revertedWith("Pausable: paused");
        })
    })
})