pragma solidity ^0.5.12; //<--- Plutôt forcer une version spécifique
 //<--- Manque une license
 //---> Manque de commentaire
contract Crowdsale { 
    
    //---> SafeMath plus utile et plus supporté en 0.8.x
   using SafeMath for uint256;
 
   address public owner; // the owner of the contract <--- Pas utilisé dans le code ?
   address public escrow; // wallet to collect raised ETH <--- payable ?
   
   uint256 public savedBalance = 0; // Total amount raised in ETH
   //--->Initialisation inutile
   
   mapping (address => uint256) public balances; // Balances in incoming Ether
 
   // Initialization
   function Crowdsale(address _escrow) public{ // ---> Mauvais nommage, constructeur ?
       owner = tx.origin; // <---  Non utilisé par la suite
       // add address of the specific contract
       escrow = _escrow;
   }
  
   // function to receive ETH <----mettre commentaire au format ethDoc
   function() public { // <--- upgrade vers receive
       //<-- abscence de check d'address et de value
       balances[msg.sender] = balances[msg.sender].add(msg.value);
       savedBalance = savedBalance.add(msg.value);
       escrow.send(msg.value); //<--- transfer ou call plutot que send 
   }
  
   // refund investisor <----mettre commentaire au format ethDoc
   function withdrawPayments() public{
       address payee = msg.sender;  // <--- Address doit etre payable
       uint256 payment = balances[payee];
 
       //<--- Manque un assert sur payment
       payee.send(payment);//<--- transfer ou call plutot que send car pas de gestion d'exception & 
 
       savedBalance = savedBalance.sub(payment); 
       balances[payee] = 0; 
   }
}
