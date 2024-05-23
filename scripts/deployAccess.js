const hre = require("hardhat");

async function main() {
  const AccessManagement = await hre.ethers.getContractFactory(
    "AccessManagement"
  );
  const accessManagement = await AccessManagement.deploy();

  // No need to call `.deployed()` explicitly

  console.log("AccessManagement deployed to:", accessManagement.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
