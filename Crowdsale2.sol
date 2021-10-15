// SPDX-License-Identifier: MIT


pragma solidity 0.8.0;
 
/// @notice The Crowdsale2 contract is for .. blah
/// @author Pierre-Emmanuel CHAUT
contract Crowdsale2 {
 
 

   address payable private escrow; // wallet to collect raised ETH
   uint256 public savedBalance; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
   bool private mutexProtectReintrance;
 
   /** Initialization of the connector wallet
    * @param _escrow wallet to collect raised ETH
    */ 
   constructor(address payable _escrow) {
       // add address of the specific contract
       escrow = _escrow;
   }
  
   /// @dev function to receive ETH and transfer them to escrow wallet 
   receive() external payable {
       require(mutexProtectReintrance,"reintrance Detected");
       require(msg.value>0);  // do not consume gas if value is null
       require(msg.sender!=address(0));
       balances[msg.sender] += msg.value;
       savedBalance += msg.value;

        // We transfer the poney to the escrow
       mutexProtectReintrance=false;
       (bool success,) =escrow.call{value:msg.value}("");
       require(success);
       mutexProtectReintrance=true;
   }
  
   /// @notice refund investor
   function withdrawPayments() public{
       require(mutexProtectReintrance,"reintrance Detected");
       require(msg.sender!=address(0));
       address payable payee = payable(msg.sender);
       uint256 payment = balances[payee];
       assert(payment>0);   // Make sure there are funds to transfer
       
       mutexProtectReintrance=false;
       (bool success,) =payee.call{value:payment}("");
       require(success);
 
       savedBalance -= payment;
       balances[payee] = 0;
       mutexProtectReintrance=true;
   }
}
