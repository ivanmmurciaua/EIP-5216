// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC1155.sol";

/**
 * @dev Extension of {ERC1155} that allows to approve their tokens by Id.
 */
abstract contract ERC1155ApprovalById is ERC1155 {

    // Mapping from account to operator approvals by id
    mapping(address => mapping(address => mapping(uint256 => bool))) private _operatorApprovalsById;

    /**
     * @dev Emmited when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `id`.
     */
    event ApprovalById(address indexed account, address indexed operator, uint256 id, bool approved);

    /**
     * @dev Grants permision to `operator` to transfer the caller's tokens, according to `id`,
     *
     * Emits an {ApprovalById} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalById(address operator, uint256 id, bool approved) public virtual {
        _setApprovalById(_msgSender(), operator, id, approved);
    }

    /**
     * @dev Returns if `operator` is approved to transfer ``account``'s tokens, according to `id`.
     *
     */
    function isApprovedById(address account, address operator, uint256 id) public view virtual returns (bool) {
        return _operatorApprovalsById[account][operator][id];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     *
     */
    function safeTransferFromById(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual {
        require(
            from == _msgSender() || isApprovedById(from, _msgSender(), id),
            "ERC1155ApprovalById: caller is not owner nor approved for this id"
        );
        // Once the Id has been checked, the same function is called
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     *
     */
    function safeBatchTransferFromById(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual {
        require(
            from == _msgSender() || _checkApprovalForBatch(from, _msgSender(), ids),
            "ERC1155ApprovalById: transfer caller is not owner nor approved for some id"
        );
        // Once the Ids have been checked, the same function is called
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Checks if all ids are permissioned for `to`.
     *
     */
    function _checkApprovalForBatch(
        address from, 
        address to, 
        uint256[] memory ids
    ) internal view virtual returns (bool) {
        for (uint256 i = 0; i < ids.length; i++) {
            require(isApprovedById(from, to, ids[i]), "ERC1155ApprovalById: transfer caller is not approved for id");
        }
        return true;
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens by id
     *
     * Emits a {ApprovalById} event.
     */
    function _setApprovalById(
        address owner,
        address operator,
        uint256 id,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC1155ApprovalById: setting approval status for self");
        _operatorApprovalsById[owner][operator][id] = approved;
        emit ApprovalById(owner, operator, id, approved);
    }

}
