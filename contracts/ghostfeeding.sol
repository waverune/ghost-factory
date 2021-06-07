pragma solidity >=0.5.0 <0.6.0;

import "./ghostfactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract GhostFeeding is GhostFactory {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _ghostId) {
    require(msg.sender == ghostToOwner[_ghostId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Ghost storage _ghost) internal {
    _ghost.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Ghost storage _ghost) internal view returns (bool) {
      return (_ghost.readyTime <= now);
  }

  function feedAndMultiply(uint _ghostId, uint _targetDna, string memory _species) internal onlyOwnerOf( _ghostId){
    Ghost storage myGhost = ghosts[_ghostId];
    require(_isReady(myGhost));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myGhost.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createGhost("NoName", newDna);
    _triggerCooldown(myGhost);
  }

  function feedOnKitty(uint _ghostId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_ghostId, kittyDna, "kitty");
  }
}
