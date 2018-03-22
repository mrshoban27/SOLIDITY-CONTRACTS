pragma solidity ^0.4.20;
contract UserManagement{
   
   struct details{
        string name;
        uint age;
        uint amount;
    
   }
   mapping(address=>details) account;
   
   mapping(address=>bool) userexists;
   address[] add;
  
   
  function RegisterUser(string _name,uint _age)public{
       require(userexists[msg.sender]==false);
       require(_age>5&&_age<100);
       address useraddress=msg.sender;
       userexsit(useraddress);
       account[useraddress].name=_name;
       account[useraddress].age=_age;
       account[useraddress].amount=msg.sender.balance;
       add.push(useraddress);
     }
     
   function userexsit(address _address)internal{
   userexists[_address]=true;
     }
  function FindUserByAddress(address _address)public constant returns(string,uint,uint){
      return(account[_address].name,account[_address].age,account[_address].amount);
      
     }
  function GetBalance(address _address)public constant returns(uint){
      return account[_address].amount;
      
     }
  function DeleteUserByaddress(address _address)public{
              require(userexists[_address]==true);
               delete account[_address];
               for(uint256 i=0;i<add.length;i++){
                   if(add[i]==_address){
                       delete add[i];
                       userexists[msg.sender]=false;
                       
                    
                   }
               }
          
          
     }
  function ListAll()public constant returns (address[]){
      return add;
     }
}
