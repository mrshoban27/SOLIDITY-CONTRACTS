pragma solidity ^0.4.20;
contract mycontract{
    struct details{
       address studentid;
       uint amount;
       bool exists;
       uint code;
       
    }
    function mycontract(){
        owner=msg.sender;
    }
    modifier onlyowner{
       if(msg.sender==owner){
           _;
       } 
       else
       throw;
    }
    mapping(address=>details) add;
    address owner;
    uint ReferenceCode;
    uint[] store;
    address[] storeadd;
    uint[] storeval;
    function()payable{
        
    }
    function register(address _address,uint _ReferenceCode )payable public returns(uint){
       
        if(ReferenceCode==0){
             if(add[_address].exists==false){
        add[_address].studentid=_address;
        add[_address].amount=msg.value;
        ReferenceCode++;
        store.push(ReferenceCode);
        storeadd.push(_address);
        storeval.push(add[_address].amount);
         userexists(_address);
        return ReferenceCode;
        }
            else
            throw;
        }
        else if(ReferenceCode>0){
             if(add[_address].exists==false){
         for(uint i=0;i<store.length;i++){
            if(ReferenceCode==store[i]){
            add[_address].studentid=_address;
            add[_address].amount=msg.value;
            add[_address].amount+=(add[_address].amount)/10;
            }
            ReferenceCode++;
            store.push(ReferenceCode);
            storeadd.push(_address);
            storeval.push(add[_address].amount);
            userexists(_address);
            return ReferenceCode;
            }
             }
             else
             throw;
        }
        
    }
    function userexists(address _address)internal{
     add[_address].exists=true;
     }
    function ethersending()public onlyowner{
        uint j;
        for(uint i=0;i<storeadd.length;i++){
            storeadd[j].transfer(storeval[i]);
            j++;
        }
    }
        
}
