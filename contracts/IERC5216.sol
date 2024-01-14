// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

/**
 * @title ERC-1155 Allowance Extension
 * Note: the ERC-165 identifier for this interface is 0x1be07d74
 */
interface IERC5216 is IERC1155 {

    /**
     * @notice Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `id` and with an amount: `amount`.
     */
    event Approval(address indexed account, address indexed operator, uint256 id, uint256 amount);

    /**
     * @notice Grants permission to `operator` to transfer the caller's tokens, according to `id`, and an amount: `amount`.
     * Emits an {Approval} event.
     *
     * Requirements:
     * - `operator` cannot be the caller.
     */
    function approve(address operator, uint256 id, uint256 amount) external;

    /**
     * @notice Returns the amount allocated to `operator` approved to transfer `account`'s tokens, according to `id`.
     */
    function allowance(address account, address operator, uint256 id) external view returns (uint256);
}