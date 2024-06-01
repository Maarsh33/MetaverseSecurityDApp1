const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const IdentityAndAccessManagement = await ethers.getContractFactory(
    "IdentityAndAccessManagement"
  );
  const identityAndAccessManagement =
    await IdentityAndAccessManagement.deploy();

  console.log(
    "IdentityAndAccessManagement address:",
    identityAndAccessManagement.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
