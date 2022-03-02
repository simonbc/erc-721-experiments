const { ethers } = require("hardhat");

async function main() {
  const Contract = await ethers.getContractFactory("SuperMarioWorld");
  const superMarioWorld = await Contract.deploy("SuperMarioWorld", "SPRM");

  await superMarioWorld.deployed();
  console.log("Success! Contract was deployed to:", superMarioWorld.address);

  await superMarioWorld.mint(
    "https://ipfs.io/ipfs/QmVSGqhjisvDgYJLGekkch7Cr3WLrNmAGpAy7qKkri9sbw"
  );

  // await superMarioWorld.mint(
  //   "https://ipfs.io/ipfs/QmSAdmL5ReWFLdQahN4ybDLph192hqky92Q15HUP4gbRt9"
  // );

  console.log("NFT successfully minted");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
