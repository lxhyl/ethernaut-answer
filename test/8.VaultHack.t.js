
// vault deploy at https://goerli.etherscan.io/address/0xe0e962F2d202A742bD3Af2f38F9ac669bfEec957#code


const { ethers } = require("ethers");

const VAULT = `0xe0e962F2d202A742bD3Af2f38F9ac669bfEec957`
const ALCHEMY_API_KEY = `wh0r3i6JeVmVljf6920SkF8x5e4kITQC`

const provider = ethers.getDefaultProvider("goerli", {
  alchemy: ALCHEMY_API_KEY,
})

async function getStorage(slot) {
  const data = await provider.getStorageAt(VAULT, slot)
  console.log(`slot ${slot}:`, data);
}

getStorage(1)