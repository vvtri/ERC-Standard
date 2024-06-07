const { ethers, upgrades } = require('hardhat');
const {
  getImplementationAddressFromProxy,
  getImplementationAddress,
} = require('@openzeppelin/upgrades-core');

async function main() {
  const Box4 = await ethers.getContractFactory(
    process.env.CONTRACT_NAME_FOR_UPGRADE,
  );
  const box4 = await upgrades.upgradeProxy(process.env.PROXY_ADDRESS, Box4, {
    kind: 'uups',
    // initializer: 'initialize',
    // call: {
    //   fn: 'initialize',
    //   args: [42],
    // },
  });
  await box4.waitForDeployment();

  console.log('proxy address', await box4.getAddress());

  console.log(
    'new implementation address',
    await getImplementationAddress(ethers.provider, process.env.PROXY_ADDRESS),
  );
}

main();
