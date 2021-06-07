pragma solidity >=0.5.0 <0.6.0;

import "./ghostattack.sol";
import "./erc721.sol";
import "./safemath.sol";

contract GhostOwnership is GhostAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) ghostApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerGhostCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return ghostToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerGhostCount[_to] = ownerGhostCount[_to].add(1);
    ownerGhostCount[msg.sender] = ownerGhostCount[msg.sender].sub(1);
    ghostToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
      require (ghostToOwner[_tokenId] == msg.sender || ghostApprovals[_tokenId] == msg.sender);
      _transfer(_from, _to, _tokenId);
    }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
      ghostApprovals[_tokenId] = _approved;
      emit Approval(msg.sender, _approved, _tokenId);
    }

}
