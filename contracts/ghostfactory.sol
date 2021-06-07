pragma solidity >=0.5.0 <0.6.0 ;

import "./ownable.sol";
import "./safemath.sol";

contract GhostFactory is Ownable {


  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewGhost(uint ghostId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Ghost {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Ghost[] public ghosts;

  mapping (uint => address) public ghostToOwner;
  mapping (address => uint) ownerGhostCount;

  function _createGhost(string memory _name, uint _dna) internal {
    uint id = ghosts.push(Ghost(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    ghostToOwner[id] = msg.sender;
    ownerGhostCount[msg.sender] = ownerGhostCount[msg.sender].add(1);
    emit NewGhost(id, _name, _dna);
  }

  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function createRandomGhost(string memory _name) public {
    require(ownerGhostCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createGhost(_name, randDna);
  }

}
