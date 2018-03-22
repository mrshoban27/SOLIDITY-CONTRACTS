pragma solidity ^0.4.20;
pragma experimental ABIEncoderV2;
contract Funding1{
 struct details{
     string name;
     string Email;
     uint amount;
     bool exists;
     address sender;
     uint tran;
     }
     
     address owner;
     function Funding1()public{
         owner=msg.sender;
     }
     modifier OnlyOwner{
         require(owner==msg.sender);
         _;
     }
    
     mapping(address=>details) account;
     mapping(string=>bool) valid;
     event Transactiondetails(address _from,uint _value);
     address[] add;
     string[] add1;
     string[] add2;
     uint[] add3;
    
     function Registration(address _address,string _name,string _Email)public {
        
        require(account[_address].exists==false);
         require(valid[_Email]==false);
         userexists(_address);
         account[_address].sender=_address;
         account[_address].name=_name;
         account[_address].Email=_Email;
         account[_address].amount=_address.balance;
         add.push(_address);
   
     }
     function userexists(address _address)internal{
     account[_address].exists=true;
     }
     function emailvalid(string _Email)internal returns(bool){
         valid[_Email]=true;
     }
    function ViewData(address _address)public view returns(address,string,string){
         return(account[_address].sender,account[_address].name,account[_address].Email);
     }
     
     function funding()payable public{
         require(add.length!=0);
         add3.push(msg.value);
         account[msg.sender].tran=msg.value;
        
         Transactiondetails(msg.sender,msg.value);
     }
     function ReleaseFund(address _senderaddress)OnlyOwner public {
         
         _senderaddress.transfer(account[_senderaddress].tran);
     }
     function BalanceInContract()public constant returns(uint){
         return (this.balance);
     }
     function ListAllUsers()OnlyOwner public constant returns(address[],uint[]){
         return (add,add3);
     }
     
 
}   
