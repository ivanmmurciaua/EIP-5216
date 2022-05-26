## About the project

This project starts when I realized while doing an implementation with the ERC1155 standard that the ERC1155 approval was made for all tokens (`setApprovalForAll`) regardless of quantities or/and ids.

This is quite dangerous, because if you don't revoke that approval (`setApprovalForAll(operator, false)`), you let the operator do whatever he wants whenever he wants with all your tokens.

ivanmmurciaua is not liable for any outcomes as a result of using ERC1155ApprovalByAmount. DYOR.

### ERC1155ApprovalByAmount

#### Usage

```solidity
pragma solidity ^0.8.0;

import "./ERC1155/ERC1155.sol";
import "./ERC1155/extensions/ERC1155ApprovalByAmount.sol";

contract ReferenceImplementation is ERC1155, ERC1155ApprovalByAmount { ... }
```

#### Functions

| Name         | Params | Description |
|:--------------:|:-----:|:------------:|
| approve | address operator, uint256 id, uint256 amount | Grants permission to operator to transfer caller's tokens according to id and with a limit amount |
| allowance | address account, address operator, uint256 id | Returns the amount for operator approved to transfer account's tokens according to id |

safeTransferFrom & safeBatchTransferFrom are override from ERC1155 and implemented as example in `ReferenceImplementation.sol` contract. 

### Tests

```
ERC1155ApprovalByAmount
    approve
      ✔ Approve id 0 for U1 with an amount of 10 (214ms)
      ✔ Should revert when owner try to approve himself (150ms)
    safeTransferFrom
      ✔ Should revert when caller isn't the from param (136ms)
      ✔ Should revert when id to transfer is not approved and caller != from (164ms)
      ✔ Transfer 10 1155-0 to U2 by owner (216ms)
      ✔ Transfer 10 1155-0 to U1 call by himself (267ms)
      ✔ Should revert when U1 try to transfer 1 1155-0 to himself with allowance actual in 0 (142ms)
    safeBatchTransferFrom
      ✔ Approve id 1 for U1 with an amount of 10 (184ms)
      ✔ Should be reverted because Id 0 is not approved for U1 (106ms)
      ✔ Transfer 10 of 0 and 1 from owner to U2 (367ms)
      ✔ Approve for Id 0 and transfer 10 of 0 and 1 to U1 (464ms)


  12 passing (6s)
```

### TODO

- [X] Testing
- [X] Post in OZ Forum
- [X] Post in FEM
- [ ] Discuss
  - [X] Remove redundant ById version
  - [X] Fit to ERC-20 API
  - [X] Remove safe(Batch)TransferFromByAmount functions and override from ERC1155
- [ ] Be a real extension approved by the community

### Improvements

- Check <= alternative
- Review in `safeTransferFrom` implemented example, a bad practice when from == _msgSender(), enters in unchecked assignation for himself (weird)
- ...