const { ethers, upgrades } = require('hardhat');
const { getImplementationAddress } = require('@openzeppelin/upgrades-core');

async function main() {
  const Box = await ethers.getContractFactory(
    process.env.CONTRACT_NAME_FOR_DEPLOY,
  );
  const box = await upgrades.deployProxy(Box, [123], {
    kind: 'uups',
    initializer: 'initialize',
  });
  await box.waitForDeployment();

  console.log('box', box);

  console.log('proxy address', await box.getAddress());
  console.log(
    'new implementation address',
    await getImplementationAddress(ethers.provider, process.env.PROXY_ADDRESS),
  );
}

main();
