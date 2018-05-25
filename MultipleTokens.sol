pragma solidity ^0.4.20;
pragma experimental ABIEncoderV2;
interface token{
    function buyTokens(address receiver)payable external;
    function balanceOf(address who)external constant returns(uint256);
}
contract MultipleTokens{
    struct tokenOwners{
        address tokenOwner;
        token tokenAddress;
    }
    mapping ( address => tokenOwners ) owners;
    mapping ( string => address ) tokenName;
    string[] name;
    event TokenDetails(string TokenName,address TokenAddress);
    
    function tokenOwnerRegistration(token _tokenAddress,string _tokenName)public{
        require(_tokenAddress.balanceOf(msg.sender)>0);
        owners[msg.sender].tokenOwner=msg.sender;
        owners[msg.sender].tokenAddress=_tokenAddress;
        tokenName[_tokenName]=msg.sender;
        name.push(_tokenName);
        emit TokenDetails(_tokenName,_tokenAddress);
    }
    
    function buyToken(string _tokenName)payable public{
        require(tokenName[_tokenName]!=0x0);
        owners[tokenName[_tokenName]].tokenAddress.buyTokens.value(msg.value)(msg.sender);
    }
    
    
    function show()public constant returns(string[]){
        return name;
    }
    
}
