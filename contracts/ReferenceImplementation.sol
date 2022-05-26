// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC1155/ERC1155.sol";
import "./ERC1155/extensions/ERC1155Supply.sol";
import "./ERC1155/extensions/ERC1155ApprovalByAmount.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract ReferenceImplementation is ERC1155, Ownable, Pausable, ERC1155Supply, ERC1155ApprovalByAmount {
    constructor() ERC1155("") {}

    event Minted(address to, uint256 id, uint256 amount, bytes data);
    event BatchMinted(address to, uint256[] ids, uint256[] amounts, bytes data);

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
        emit Minted(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
        emit BatchMinted(to, ids, amounts, data);
    }

    /**
     * @dev safeTransferFrom implementation for using ApprovalByAmount extension
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()) || allowance(from, _msgSender(), id) >= amount,
            "ERC1155: caller is not owner nor approved nor approved for amount"
        );
        if(!isApprovedForAll(from, _msgSender())) {
            unchecked {
                _allowances[from][_msgSender()][id] -= amount;
            }
        }
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev safeBatchTransferFrom implementation for using ApprovalByAmount extension
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()) || _checkApprovalForBatch(from, _msgSender(), ids, amounts),
            "ERC1155: transfer caller is not owner nor approved nor approved for some amount"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}