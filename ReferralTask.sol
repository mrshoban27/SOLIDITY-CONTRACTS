pragma solidity ^0.4.20;

contract myContract{
    
    struct userDetails{
        
        address id;
        uint amount;
        bool exists;
        
    }
    
    address owner;
    mapping(address => userDetails) users;
    uint referenceCode;
    uint[] store;
    address[] storeAdd;
    uint[] storeValue;
    
    function myContract(){
        owner=msg.sender;
    }
    
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }
    
    function () payable{
        
    }
    
    function registration(address _add,uint _referenceCode) payable public returns (uint){
        
        if(_referenceCode==0){
            if(users[_add].exists==false){
                users[_add].id=_add;
                users[_add].amount=msg.value;
                referenceCode++;
                store.push(referenceCode);
                storeAdd.push(_add);
                storeValue.push(users[_add].amount);
                userExists(_add);
                return referenceCode;
            }
            else
            throw;
        }
        else if(_referenceCode>0){
            if(users[_add].exists==false){
                for(uint i=0;i<store.length;i++){
                    if(_referenceCode==store[i]){
                       users[_add].id=_add;
                       users[_add].amount=msg.value;
                       users[storeAdd[i]].amount+=(users[_add].amount)/10;
                       storeValue[i]=users[storeAdd[i]].amount;
                    }
                }
                    referenceCode++;
                    store.push(referenceCode);
                    storeAdd.push(_add);
                    storeValue.push(users[_add].amount);
                    userExists(_add);
                    return referenceCode;
                
            }
            else
            throw;
        }
        
    }
    
    function userExists(address _add) internal{
        
        users[_add].exists=true;
    }
    
    function returnBackEther() public onlyOwner{
        
        for(uint i=0;i<storeAdd.length;i++){
            storeAdd[i].transfer(storeValue[i]);
        }
    }
    
    
    function kill(){
        selfdestruct(msg.sender);
    }
}
