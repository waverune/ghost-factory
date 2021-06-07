pragma solidity >=0.5.0 <0.6.0;

import "./ghostfeeding.sol";

contract GhostHelper is GhostFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _ghostId) {
    require(ghosts[_ghostId].level >= _level);
    _;
  }

  /* function withdraw() external onlyOwner {
    address _owner = owner();
    _owner.transfer(address (this).balance);
  } */

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _ghostId) external payable {
    require(msg.value == levelUpFee);
    ghosts[_ghostId].level = ghosts[_ghostId].level.add(1);
  }

  function changeName(uint _ghostId, string calldata _newName) external aboveLevel(2, _ghostId) onlyOwnerOf(_ghostId) {
    ghosts[_ghostId].name = _newName;
  }

  function changeDna(uint _ghostId, uint _newDna) external aboveLevel(20, _ghostId) onlyOwnerOf(_ghostId) {
    ghosts[_ghostId].dna = _newDna;
  }

  function getGhostsByOwner(address _owner) external view returns( uint[] memory ) {
    uint[] memory result = new uint[] (ownerGhostCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < ghosts.length; i++) {
      if (ghostToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
