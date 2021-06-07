const ghostfactory = artifacts.require("./ghostfactory.sol");

module.exports = function(deployer) {
  deployer.deploy(ghostfactory);
};
