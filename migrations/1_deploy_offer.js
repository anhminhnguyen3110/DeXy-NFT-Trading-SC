var Purchasing = artifacts.require("../contracts/Purchasing.sol");

module.exports = function (deployer) {
  deployer.deploy(Purchasing);
};
