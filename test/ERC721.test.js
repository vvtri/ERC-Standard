const { ethers } = require('hardhat');
const { expect } = require('chai');

describe('ERC721', () => {
  let contract;
  let deployer, user1, user2;

  before(async () => {
    [deployer, user1, user2] = await ethers.getSigners();

    contract = await ethers.deployContract('ImplementERC721', deployer);
  });

  it('should mint nft successfully', async () => {
    const user1Address = await user1.getAddress();
    const user2Address = await user2.getAddress();
    const tokenId = 1;

    let tx = await contract.mintTo(await user1.getAddress(), 'nft1');
    await tx.wait();

    let owner = await contract.ownerOf(tokenId);
    let balance = await contract.balanceOf(user1Address);
    expect(owner).to.be.equal(user1Address);
    expect(balance).to.be.equal(1);

    tx = await contract
      .connect(user1)
      .safeTransferFrom(user1Address, user2Address, tokenId);
    await tx.wait();

    owner = await contract.ownerOf(tokenId);
    expect(owner).to.be.equal(user2Address);
    let balance1 = await contract.balanceOf(user1Address);
    let balance2 = await contract.balanceOf(user2Address);
    expect(balance1).to.be.equal(0);
    expect(balance2).to.be.equal(1);

    await expect(
      contract
        .connect(user1)
        .safeTransferFrom(user1Address, user2Address, tokenId),
    ).to.be.rejected;

    tx = await contract.connect(user2).burn(tokenId);
    await tx.wait();

    balance2 = await contract.balanceOf(user2Address);
    expect(balance2).to.be.equal(0);
  });
});
