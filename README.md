## About the project

This project starts when I realized while doing an implementation with the ERC1155 standard that the ERC1155 approval was made for all tokens (`setApprovalForAll`) regardless of quantities or/and ids.

This is quite dangerous, because if you don't revoke that approval (`setApprovalForAll(operator, false)`), you let the operator do whatever he wants whenever he wants with all your tokens.

This project has 2 extensions on it which are located in `./contracts/ERC1155/extensions` folder and used by the SC located in `./contracts/My1155.sol`.

ivanmmurciaua is not liable for any outcomes as a result of using ERC1155ApprovalById. DYOR.

#### ERC1155ApprovalById

##### Usage

```solidity
pragma solidity ^0.8.0;

import "./ERC1155/ERC1155.sol";
import "./ERC1155/extensions/ERC1155ApprovalById.sol";

contract My1155 is ERC1155, ERC1155ApprovalById { ... }
```

##### Functions

| Name         | Params | Description |
|:--------------:|:-----:|:------------:|
| setApprovalById | address operator, uint256 id, bool approved | Grants permission to operator to transfer caller's tokens according to id |
| isApprovedById | address account, address operator, uint256 id | Returns if operator is approved to transfer account's tokens according to id |
| safeTransferFromById | address from, address to, uint256 id, uint256 amount, bytes memory data | Uses `isApprovedById` and uses `_safeTransferFrom` from standard to transfer tokens |
| safeBatchTransferFromById | address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data | Uses an internal function named `_checkApprovalForBatch` which checks if every id is approved |


#### ERC1155ApprovalByAmount

##### Usage

```solidity
pragma solidity ^0.8.0;

import "./ERC1155/ERC1155.sol";
import "./ERC1155/extensions/ERC1155ApprovalByAmount.sol";

contract My1155 is ERC1155, ERC1155ApprovalByAmount { ... }
```

##### Functions

| Name         | Params | Description |
|:--------------:|:-----:|:------------:|
| setAllowance | address operator, uint256 id, uint256 amount | Grants permission to operator to transfer caller's tokens according to id and with a limit amount |
| allowanceById | address account, address operator, uint256 id | Returns the amount for operator approved to transfer account's tokens according to id |
| safeTransferFromByAmount | address from, address to, uint256 id, uint256 amount, bytes memory data | Uses `allowanceById`, substract the amount from allowance, and uses `_safeTransferFrom` from standard to transfer tokens |
| safeBatchTransferFromByAmount | address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data | Uses an internal function named `_checkApprovalForBatch` which checks if every id with the amount is approved and substract from allowance |

### Tests

```
ERC1155ApprovalById
    setApprovalById  
      √ Approve id 0 for U1 (82ms)
      √ Should revert when owner try to approve himself (71ms)
    safeTransferFromById
      √ Should revert when caller isn't the from param (64ms)
      √ Should revert when id to transfer is not approved and caller != from (46ms)
      √ Transfer 10 1155-0 to U2 by owner (85ms)
      √ Transfer 10 1155-0 to U1 call by himself (83ms)
    safeBatchTransferFromById
      √ Should be reverted because Id 1 is not approved for U1 (60ms)
      √ Transfer 10 of 0 and 1 from owner to U2 (130ms)
      √ Approve for Id 1 and transfer 10 of 0 and 1 to U1 (164ms)

  ERC1155ApprovalByAmount
    setAllowance
      √ Approve id 0 for U1 with an amount of 10 (70ms)
      √ Should revert when owner try to approve himself (40ms)
    safeTransferFromByAmount
      √ Should revert when caller isn't the from param (52ms)
      √ Should revert when id to transfer is not approved and caller != from (36ms)
      √ Transfer 10 1155-0 to U2 by owner (95ms)
      √ Transfer 10 1155-0 to U1 call by himself (103ms)
      √ Should revert when U1 try to transfer 1 1155-0 to himself with allowance actual in 0 (41ms)
    safeBatchTransferFromByAmount
      √ Approve id 1 for U1 with an amount of 10 (79ms)
      √ Should be reverted because Id 0 is not approved for U1 (42ms)
      √ Transfer 10 of 0 and 1 from owner to U2 (126ms)
      √ Approve for Id 0 and transfer 10 of 0 and 1 to U1 (200ms)
```

### TODO

- [X] Testing
- [X] Post in OZ Forum
- [X] Post in FEM
- [ ] Discuss
- [ ] Open an issue in OpenZeppelin ??
- [ ] Open a PR ??
- [ ] Be a real extension approved by the community

### Improvements

- Check <= alternative
- in ByAmount, review in `safeTransferFromByAmount` a bad practice when from == _msgSender(), enters in unchecked assignation for himself (weird)
- ...