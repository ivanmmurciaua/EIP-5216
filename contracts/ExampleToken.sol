// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC5216.sol";

contract ExampleToken is ERC5216, Ownable {
    constructor() ERC1155("") Ownable(msg.sender){}

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public {
        _mintBatch(to, ids, amounts, data);
    }
}