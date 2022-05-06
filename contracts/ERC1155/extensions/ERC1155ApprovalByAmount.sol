// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC1155.sol";

/**
 * @dev Extension of {ERC1155} that allows you to approve your tokens by amount and id.
 */
abstract contract ERC1155ApprovalByAmount is ERC1155 {

    // Mapping from account to operator approvals by id and amount.
    mapping(address => mapping(address => mapping(uint256 => uint256))) private _operatorApprovalsByAmount;

    /**
     * @dev Emmited when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `id` and with an amount: `amount`.
     */
    event ApprovalByAmount(address indexed account, address indexed operator, uint256 id, uint256 amount);

    /**
     * @dev Grants permision to `operator` to transfer the caller's tokens, according to `id`, and an amount: `amount`.
     *
     * Emits an {ApprovalByAmount} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setAllowance(address operator, uint256 id, uint256 amount) public virtual {
        _setAllowance(_msgSender(), operator, id, amount);
    }

    /**
     * @dev Returns the amount allocated to `operator` approved to transfer ``account``'s tokens, according to `id`.
     */
    function allowanceById(address account, address operator, uint256 id) public view virtual returns (uint256) {
        return _operatorApprovalsByAmount[account][operator][id];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFromByAmount(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual {
        require(
            from == _msgSender() || allowanceById(from, _msgSender(), id) >= amount,
            "ERC1155ApprovalByAmount: caller is not owner nor approved for that amount"
        );
        unchecked { _operatorApprovalsByAmount[from][_msgSender()][id] -= amount; }

        // Once the id and amount have been checked, the same function is called.
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFromByAmount(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual {
        require(
            from == _msgSender() || _checkApprovalForBatch(from, _msgSender(), ids, amounts),
            "ERC1155ApprovalByAmount: transfer caller is not owner nor approved for this op"
        );
        // Once the ids and amounts have been checked, the same function is called.
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Checks if all ids and amounts are permissioned for `to`. 
     *
     * Requirements:
     *
     * - `ids` and `amounts` length should be equal.
     */
    function _checkApprovalForBatch(
        address from, 
        address to, 
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual returns (bool) {
        require(ids.length == amounts.length, "ERC1155ApprovalByAmount: ids and amounts length mismatch");
        for (uint256 i = 0; i < ids.length; i++) {
            require(allowanceById(from, to, ids[i]) >= amounts[i], "ERC1155ApprovalByAmount: operator is not approved for that id or amount");
            unchecked { _operatorApprovalsByAmount[from][to][ids[i]] -= amounts[i]; }
        }
        return true;
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens by id and amount.
     *
     * Emits a {ApprovalByAmount} event.
     */
    function _setAllowance(
        address owner,
        address operator,
        uint256 id,
        uint256 amount
    ) internal virtual {
        require(owner != operator, "ERC1155ApprovalByAmount: setting approval status for self");
        _operatorApprovalsByAmount[owner][operator][id] = amount;
        emit ApprovalByAmount(owner, operator, id, amount);
    }
}
