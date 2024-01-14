import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    compilers : [
      {
        version : "0.8.21",
        settings : {
          optimizer: {
            enabled: true
          }
        }
      }
    ]
  },
};

export default config;
