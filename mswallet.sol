pragma solidity ^0.4.20;
contract Multiwallet{
   
   address[] add;
  
   
  mapping(address=>bool) isowner;
  address[] admins;
   function Multiwallet(address _add1,address _add2)public{
      owner=msg.sender;
      isowner[owner]=true;
      isowner[_add1]=false;
      isowner[_add2]=false;
      admins.push(owner);
     add.push(_add1);
     add.push(_add2);
     add.push(owner);
     
     
   }
   
   address owner;
  
   
   modifier OnlyOwner{
   require(msg.sender==owner);
   _;
   }
   function ()payable public {
      
   }
   
   
   
   function ListAll()public constant returns(address[]){
   
       return add;
   }
    function balance(address _address) public constant returns(uint){
       return(_address.balance);
   }
   
   function kill()public OnlyOwner{
       suicide(this);
   }
   function SendingEther(address _to,uint amount) public  {
       if(isowner[msg.sender]==true){
           
       if(amount<=10000000000000000000)
            { 
                _to.transfer(amount);
                
            }
           
       }
           }
       
       
   
   function addAdmin(address _address)OnlyOwner public {
       
        admins.push(_address);
       isowner[_address]=true;
      
   }
   function remove(address _address)OnlyOwner public {
       
       for(uint i=0;i<admins.length;i++){
           isowner[_address]=false;
           if(admins[i]==_address){
               delete admins[i];
               
              }
       }
    
   }
  function ViewAdmin()public constant returns(address[]){
   return(admins);
  }
   
 
}