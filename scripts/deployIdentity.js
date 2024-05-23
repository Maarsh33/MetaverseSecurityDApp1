const hre = require("hardhat");

async function main() {
  const IdentityManagement = await hre.ethers.getContractFactory(
    "IdentityManagement"
  );
  const identityManagement = await IdentityManagement.deploy();

  // No need to call `.deployed()` explicitly

  console.log("IdentityManagement deployed to:", identityManagement.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
