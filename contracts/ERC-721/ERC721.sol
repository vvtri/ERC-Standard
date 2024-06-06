// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import './IERC721.sol';
import './IERC721Metadata.sol';
import '../utilities/Counter.sol';
import '../utilities/ReentranceGuard.sol';
import '../ERC-165/ERC165.sol';
import {IERC721TokenReceiver} from './IERC721TokenReceiver.sol';
// import  '@openzeppelin/contracts/token/ERC721/ERC721.sol';

import 'hardhat/console.sol';

contract ERC721 is IERC721, ERC721Metadata, ReentranceGuard, ERC165 {
  using Counters for Counter;
  mapping(uint256 tokenId => address) private _owners;
  mapping(address owner => uint256) private _balances;
  mapping(uint256 tokenId => address) private _tokenApprovals;
  mapping(address owner => mapping(address operator => bool))
    private _operatorApprovals;

  // Counter private _tokenIds;
  string private _name;
  string private _symbol;
  mapping(uint256 => string) _tokenURIs;

  constructor(string memory nameParams, string memory symbolParams) {
    _name = nameParams;
    _symbol = symbolParams;
  } //checked

  // metadata
  function _setTokenURI(
    uint256 tokenId,
    string memory tokenURIParams
  ) internal {
    _tokenURIs[tokenId] = tokenURIParams;
  } //checked

  function name() external view returns (string memory) {
    return _name;
  } //checked

  function symbol() external view returns (string memory) {
    return _symbol;
  } //checked

  function tokenURI(uint256 _tokenId) external view returns (string memory) {
    return _tokenURIs[_tokenId];
  } //checked
  // metadata

  // erc165
  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override returns (bool) {
    return
      type(IERC721).interfaceId == interfaceId ||
      type(ERC721Metadata).interfaceId == interfaceId ||
      super.supportsInterface(interfaceId);
  }
  // end erc165

  function balanceOf(address _owner) external view returns (uint256) {
    require(_owner != address(0), 'throws for queries about the zero address');
    return _balances[_owner];
  } //checked

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return _requireOwned(_tokenId);
  } //checked

  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory data
  ) public payable {
    _transfer(_from, _to, _tokenId);
    _checkOnERC721Received(_from, _to, _tokenId, data);
  } //checked

  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable {
    safeTransferFrom(_from, _to, _tokenId, '');
  } //checked

  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable {
    _transfer(_from, _to, _tokenId);
  } //checked

  function _transfer(address _from, address _to, uint256 _tokenId) internal {
    require(
      _requireOwned(_tokenId) == _from,
      '_requireOwned(_tokenId) == _from'
    );

    require(
      msg.sender == _from ||
        msg.sender == _tokenApprovals[_tokenId] ||
        isApprovedForAll(_from, msg.sender),
      'msg.sender == _from || msg.sender == _tokenApprovals[_from][_tokenId] ||  msg.sender == _operatorApprovals[_from]'
    );

    _owners[_tokenId] = _to;
    _tokenApprovals[_tokenId] = address(0);
    _balances[_from] -= 1;
    _balances[_to] += 1;

    emit Transfer(_from, _to, _tokenId);
  } //checked

  function approve(address approved, uint256 tokenId) external payable {
    address owner = _requireOwned(tokenId);
    require(
      msg.sender == _requireOwned(tokenId) ||
        isApprovedForAll(owner, msg.sender),
      'msg.sender == _requireOwned(tokenId) || isApprovedForAll(owner, msg.sender)'
    );

    _tokenApprovals[tokenId] = approved;

    emit Approval(owner, approved, tokenId);
  } //checked

  function setApprovalForAll(address operator, bool approved) external {
    require(operator != address(0), 'operator != address(0)');
    _operatorApprovals[msg.sender][operator] = approved;
    emit ApprovalForAll(msg.sender, operator, approved);
  } //checked

  function getApproved(uint256 _tokenId) external view returns (address) {
    return _tokenApprovals[_tokenId];
  } //checked

  function isApprovedForAll(
    address owner,
    address operator
  ) public view virtual returns (bool) {
    return _operatorApprovals[owner][operator];
  } // checked

  function _requireOwned(
    uint256 _tokenId
  ) internal view virtual returns (address) {
    require(_owners[_tokenId] != address(0), '_owners[_tokenId] != address(0)');

    return _owners[_tokenId];
  } //checked

  function _mint(address to, uint256 tokenId) internal {
    require(_owners[tokenId] == address(0), '_owners[tokenId] == address(0)');
    require(to != address(0), 'to != address(0)');

    _balances[to]++;
    _owners[tokenId] = to;
    emit Transfer(address(0), to, tokenId);
  } // checked

  function _safeMint(address to, uint256 tokenId) internal {
    _safeMint(to, tokenId, '');
  } // checked

  function _safeMint(
    address to,
    uint256 tokenId,
    bytes memory data
  ) internal virtual {
    _mint(to, tokenId);
    _checkOnERC721Received(address(0), to, tokenId, data);
  } //checked

  function _burn(uint256 tokenId) internal {
    address owner = _requireOwned(tokenId);
    require(
      msg.sender == owner ||
        msg.sender == _tokenApprovals[tokenId] ||
        isApprovedForAll(owner, msg.sender),
      'msg.sender == owner ||  msg.sender == _tokenApprovals[tokenId] ||     isApprovedForAll(owner, msg.sender)'
    );

    _balances[owner] -= 1;
    _owners[tokenId] = address(0);
    _tokenApprovals[tokenId] = address(0);

    emit Transfer(owner, address(0), tokenId);
  } //checked

  function _checkOnERC721Received(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) internal {
    if (to.code.length == 0) return;

    (bool success, bytes memory retval) = to.call(
      abi.encodeWithSignature(
        'onERC721Received(address,address,uint256,bytes)',
        msg.sender,
        from,
        tokenId,
        data
      )
    );
    require(success, 'success');
    require(
      bytes4(retval) == IERC721TokenReceiver.onERC721Received.selector,
      'retval == IERC721Receiver.onERC721Received.selector'
    );
  } //checked

    function totalSupply() external view returns (uint256) {

    }
}
