pragma solidity >=0.5.0 <0.6.0 ;
import "./ghosthelper.sol";

contract GhostAttack is GhostHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _ghostId, uint _targetId) external onlyOwnerOf(_ghostId) {
    Ghost storage myGhost = ghosts[_ghostId];
    Ghost storage enemyGhost = ghosts[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myGhost.winCount = myGhost.winCount.add(1);
      myGhost.level = myGhost.level.add(1);
      enemyGhost.lossCount = enemyGhost.lossCount.add(1);
      feedAndMultiply(_ghostId, enemyGhost.dna, "ghost");
    } else {
      myGhost.lossCount = myGhost.lossCount.add(1);
      enemyGhost.winCount = enemyGhost.winCount.add(1);
      _triggerCooldown(myGhost);
    }
  }
}
