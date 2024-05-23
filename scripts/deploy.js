const hre = require("hardhat");

async function main() {
  const IdentityManagement = await hre.ethers.getContractFactory(
    "IdentityManagement"
  );
  const identityManagement = await IdentityManagement.deploy(); // Use 'await' here

  // No need to call `.deployed()` explicitly

  console.log("IdentityManagement deployed to:", identityManagement.address);

  const AccessManagement = await hre.ethers.getContractFactory(
    "AccessManagement"
  );
  const accessManagement = await AccessManagement.deploy(); // Use 'await' here

  // No need to call `.deployed()` explicitly

  console.log("AccessManagement deployed to:", accessManagement.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
