## About the project

This project starts when I realized while doing an implementation with the ERC1155 standard that the ERC1155 approval was made for all tokens (`setApprovalForAll(address operator, bool approved)`) regardless of quantities or/and ids.

All the specification can be found [here](https://eips.ethereum.org/EIPS/eip-5216).

ivanmmurciaua is not liable for any outcomes as a result of using ERC1155ApprovalByAmount extension. DYOR.

### ERC1155ApprovalByAmount

#### Usage

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./ERC1155ApprovalByAmount.sol";

contract ExampleToken is ERC1155ApprovalByAmount { ... }
```

#### Functions

| Name         | Params | Description |
|:--------------:|:-----:|:------------:|
| approve | address operator, uint256 id, uint256 amount | Grants permission to operator to transfer caller's tokens according to id and with a limit amount |
| allowance | address account, address operator, uint256 id | Returns the amount for operator approved to transfer account's tokens according to id |

safeTransferFrom & safeBatchTransferFrom are override from ERC1155 and implemented [here](./contracts/ERC1155ApprovalByAmount.sol). 

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
- [X] Discuss
  - [X] Remove redundant ById version
  - [X] Fit to ERC-20 API
  - [X] Remove safe(Batch)TransferFromByAmount functions and override from ERC1155
  - [x] Make PR into EIP official repository
- [ ] Be a real extension approved by the community