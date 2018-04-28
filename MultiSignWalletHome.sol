pragma solidity ^0.4.23;
interface Token{
    function balanceOf(address who)external constant returns(uint256);
    function transfer(address to,uint256 value)external;
}

contract MultiSignWallet {
    modifier onlyOwner{
        require(owner==msg.sender);
        _;
    }
    modifier onlyOwners(address _owner){
        for(uint256 i=0;i<addressOfOwners.length;i++){
            require(_owner==addressOfOwners[i]);
            _;
        }
    }
    struct TransactionDetails{
        address sender;
        address receiver;
        uint256 noOfTokens;
        bytes32 transactionId;
    }
    address private owner;
    uint256 public approved;
    constructor()public{
        owner=msg.sender;
        addressOfOwners.push(msg.sender);
    }
   
    Token private obj;
    address[] public addressOfOwners;
    function addOwners(address[] _owners)public onlyOwner{
        for(uint256 i;i<_owners.length;i++){
            addressOfOwners.push(_owners[i]);
        }
    }
    bytes32  transactionId;
    TransactionDetails details;
    bool trnCheck;
    event Transactionid(address sender,address receiver,uint256 tokens,bytes32 transactionid);
    function transferTokens(address to,uint256 tokens)public onlyOwners(msg.sender){
        require(trnCheck==false);
        transactionId=keccak256(msg.sender);
        details.sender=msg.sender;
        details.receiver=to;
        details.noOfTokens=tokens;
        details.transactionId=transactionId;
        trnCheck=true;
        emit Transactionid(msg.sender,to,tokens,transactionId);
    }
    
    function approveOwnerToSendTokens()public onlyOwners(msg.sender){
       // require(trnCheck==true);
        if(approved<=2){
            approved++;
        }
        else{
            executeTransaction(details.receiver,details.noOfTokens);
            trnCheck=false;
        }
    }
    function executeTransaction(address to,uint256 tokens)internal{
        obj.transfer(to,tokens);
        approved=0;
    }
    
}
