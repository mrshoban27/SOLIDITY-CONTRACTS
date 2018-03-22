pragma solidity ^0.4.20;

contract strings{
    
    function concat(string _base, string _value)public constant returns(string){
        bytes memory newbase=bytes(_base);
        bytes memory newvalue=bytes(_value);
        
        string memory tmp=new string(newbase.length+newvalue.length);
        bytes memory newtmp=bytes(tmp);
        uint j=0;
        for(uint i=0;i<newbase.length;i++){
            newtmp[j++]=newbase[i];
        }
        for(i=0;i<newvalue.length;i++){
            {
                newtmp[j++]=newvalue[i];
            }
        }
        return string(newtmp);
    }
    
    function position(string _base,string _value)public constant returns(uint){
        bytes memory newbase=bytes(_base);
        bytes memory newvalue=bytes(_value);
            for(uint i=0;i<newbase.length;i++){
                if(newbase[i]==newvalue[0]){
                    return uint(i);
                }
        }
    }
    
    
    
    
}
