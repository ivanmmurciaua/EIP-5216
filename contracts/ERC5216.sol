// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./IERC5216.sol";
/**
 * @dev Extension of {ERC1155} that allows you to approve your tokens by amount and id.
 */
abstract contract ERC5216 is ERC1155, IERC5216 {

    // Mapping from account to operator approvals by id and amount.
    mapping(address => mapping(address => mapping(uint256 => uint256))) internal _allowances;

    /**
     * @dev See {IERC5216}
     */
    function approve(address operator, uint256 id, uint256 amount) public virtual {
        _approve(msg.sender, operator, id, amount);
    }

    /**
     * @dev See {IERC5216}
     */
    function allowance(address account, address operator, uint256 id) public view virtual returns (uint256) {
        return _allowances[account][operator][id];
    }

    /**
     * @dev safeTransferFrom implementation for using allowance extension
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override(IERC1155, ERC1155) {
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender) || allowance(from, msg.sender, id) >= amount,
            "ERC1155: caller is not owner nor approved nor approved for amount"
        );
        unchecked {
            _allowances[from][msg.sender][id] -= amount;
        }
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev safeBatchTransferFrom implementation for using allowance extension
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override(IERC1155, ERC1155) {
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender) || _checkApprovalForBatch(from, msg.sender, ids, amounts),
            "ERC1155: transfer caller is not owner nor approved nor approved for some amount"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Checks if all ids and amounts are permissioned for `to`. 
     *
     * Requirements:
     * - `ids` and `amounts` length should be equal.
     */
    function _checkApprovalForBatch(
        address from, 
        address to, 
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual returns (bool) {
        uint256 idsLength = ids.length;
        uint256 amountsLength = amounts.length;

        require(idsLength == amountsLength, "ERC5216: ids and amounts length mismatch");
        for (uint256 i = 0; i < idsLength;) {
            require(allowance(from, to, ids[i]) >= amounts[i], "ERC5216: operator is not approved for that id or amount");
            unchecked { 
                _allowances[from][to][ids[i]] -= amounts[i];
                ++i; 
            }
        }
        return true;
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens by id and amount.
     * Emits a {Approval} event.
     */
    function _approve(
        address owner,
        address operator,
        uint256 id,
        uint256 amount
    ) internal virtual {
        require(owner != operator, "ERC5216: setting approval status for self");
        _allowances[owner][operator][id] = amount;
        emit Approval(owner, operator, id, amount);
    }
}