const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

// Deploy and mint
describe("ERC1155", function() {

  this.beforeAll(async function(){
    try{
      provider = waffle.provider;
      [owner,u1,u2] = await ethers.getSigners();

      const __1155 = await ethers.getContractFactory("My1155");
      _1155 = await __1155.deploy();
      await _1155.deployed();
    } 
    catch(ex){
      console.error(ex);
    }
  });

  it("Mint 100 of 0,1,2 from 1155 to Owner", async function(){
    const amount = 80;
    const ids = [ 0, 1 ];
    const amounts = Array(ids.length).fill(amount);
  
    await expect(_1155.mintBatch(owner.address, ids, amounts, "0x00"),"mint 1155 to owner").to.emit(_1155, "BatchMinted");
  
    const realValue0 = await _1155.balanceOf(owner.address,0);
    const realValue1 = await _1155.balanceOf(owner.address,1);
  
    expect(realValue0).to.equal(amount);
    expect(realValue1).to.equal(amount);
  });
})

// Test suite ERC1155ApprovalById
describe("ERC1155ApprovalById", function(){
  describe("setApprovalById", function(){
    it("Approve id 0 for U1", async function(){
      const operator = u1.address;
      const id = 0;
      const approved = true;
      await expect(_1155.connect(owner).setApprovalById(operator,id,approved)).to.emit(_1155, "ApprovalById");
    });

    it("Should revert when owner try to approve himself", async function(){
      const operator = owner.address;
      const id = 0;
      const approved = true;
      await expect(_1155.connect(owner).setApprovalById(operator,id,approved)).to.be.revertedWith("ERC1155ApprovalById: setting approval status for self");
    });
  });

  describe("safeTransferFromById", function(){
    it("Should revert when caller isn't the from param", async function(){
      const from = u1.address;
      const to = u2.address;
      const id = 0;
      const amount = 10;
      const data = 0x00;
      await expect(_1155.connect(owner).safeTransferFromById(from, to, id, amount, data)).to.be.revertedWith("ERC1155ApprovalById: caller is not owner nor approved for this id");
    });

    it("Should revert when id to transfer is not approved and caller != from", async function(){
      const from = owner.address;
      const to = u1.address;
      const id = 1;
      const amount = 10;
      const data = 0x00;
      await expect(_1155.connect(u2).safeTransferFromById(from, to, id, amount, data)).to.be.revertedWith("ERC1155ApprovalById: caller is not owner nor approved for this id");
    });

    it("Transfer 10 1155-0 to U2 by owner", async function(){
      const from = owner.address;
      const to = u2.address;
      const id = 0;
      const amount = 10;
      const data = 0x00;
      await expect(_1155.connect(owner).safeTransferFromById(from, to, id, amount, data),'Transfer 10-0 to U2 by owner').to.emit(_1155, "TransferSingle");
      expect(await _1155.balanceOf(to, id),'New balance of U2').to.equal(amount);
    });

    it("Transfer 10 1155-0 to U1 call by himself", async function(){
      const from = owner.address;
      const to = u1.address;
      const id = 0;
      const amount = 10;
      const data = 0x00;
      await expect(_1155.connect(u1).safeTransferFromById(from, to, id, amount, data),'Transfer 10-0').to.emit(_1155, "TransferSingle");
      expect(await _1155.balanceOf(to, id),'New balance of U1').to.equal(amount);
    });
  });

  describe("safeBatchTransferFromById", function(){
    it("Should be reverted because Id 1 is not approved for U1", async function(){
      const from = owner.address;
      const to = u1.address;
      const amount = 10;
      const ids = [ 0, 1 ];
      const amounts = [ amount, amount ];
      const data = 0x00;
      await expect(_1155.connect(u1).safeBatchTransferFromById(from, to, ids, amounts, data)).to.be.revertedWith("ERC1155ApprovalById: transfer caller is not approved for id");
    });

    it("Transfer 10 of 0 and 1 from owner to U2", async function(){
      // safeTransfer
      const from = owner.address;
      const to = u2.address;
      const amount = 10;
      const ids = [ 0, 1 ];
      const amounts = [ amount, amount ];
      const data = 0x00;
      
      const balanceBefore = [];
      for (let i = 0; i < ids.length; i++) {
        balanceBefore.push(await _1155.balanceOf(to, ids[i]));
      }

      await expect(_1155.connect(owner).safeBatchTransferFromById(from, to, ids, amounts, data)).to.emit(_1155, "TransferBatch");

      for (let i = 0; i < ids.length; i++) {
        expect(await _1155.balanceOf(to, ids[i]),'New balance of U1 of id ' + ids[i]).to.equal(parseInt(balanceBefore[i]) + amount);        
      }
    });

    it("Approve for Id 1 and transfer 10 of 0 and 1 to U1", async function(){
      // Approve
      const operator = u1.address;
      const id = 1;
      const approved = true;
      await expect(_1155.connect(owner).setApprovalById(operator,id,approved)).to.emit(_1155, "ApprovalById");

      // safeTransfer
      const from = owner.address;
      const to = u1.address;
      const amount = 10;
      const ids = [ 0, 1 ];
      const amounts = [ amount, amount ];
      const data = 0x00;
      
      const balanceBefore = [];
      for (let i = 0; i < ids.length; i++) {
        balanceBefore.push(await _1155.balanceOf(to, ids[i]));
      }

      await expect(_1155.connect(u1).safeBatchTransferFromById(from, to, ids, amounts, data)).to.emit(_1155, "TransferBatch");

      for (let i = 0; i < ids.length; i++) {
        expect(await _1155.balanceOf(to, ids[i]),'New balance of U1 of id ' + ids[i]).to.equal(parseInt(balanceBefore[i]) + amount);        
      }
    });
  });

});