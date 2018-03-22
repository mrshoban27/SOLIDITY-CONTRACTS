pragma solidity ^0.4.20;
library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
contract IERC20 {
   
    function balanceOf(address _to) public constant returns (uint256);
    function transfer(address to, uint256 value) public;
    function transferFrom(address from, address to, uint256 value);
    function approve(address spender, uint256 value) public;
    function allowance(address owner, address spender) public constant returns(uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract RoadToken is IERC20 {
    
    using SafeMath for uint256;
   
    //Token Properties
    string public name="Road Token";
    string public symbol="ROAD";
    uint256 public decimals=18;
    
    //Token allocation
    uint256 public  total_supply=400000000e18;
    uint256 public _presale = 20000000e18;
    uint256 public _tokensaleCap = 320000000e18;
    uint256 public teamAllocation=40000000e18;
    uint256 public marketallocation=20000000e18;
    uint256 public _soldPresalecap;
    uint256 public _soldTokensalecap;
    //stage presale or crowdsale
    enum Stage {PRESALE, TOKENSALE, FINISH}
    Stage public stage;
    
    //Strat time and end tme for token purchase
    uint256 public startTime ;
    uint256 public endTime ;
    //Minimum goal and maximum goal
    uint256 public softCap = 5000 ether;
    uint256 public hardCap = 60000 ether;
   
    mapping (address=>uint) public balances;
    //Contract Runner and Token holder address
    address public owner;
    address public tokenOwner;
    //Tokens Per Eth 
    uint public tokenPrice=3500;
    
    mapping (address => mapping(address => uint256)) allowed;
    //Minmum amount  to buy a token
    uint public minContribAmount = 0.1 ether; 
    // amount of raised money in wei
    uint256 public fundRaised = 0;
    //Event for token purchase
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
     }
    function RoadToken(uint256 _startTime, uint256 _endTime, address _wallet) {
        startTime = _startTime;
        endTime = _endTime;
        tokenOwner = _wallet;
        owner=msg.sender;
        balances[tokenOwner] = total_supply;
	    stage = Stage.PRESALE;
  }
  // fallback function can be used to buy tokens
  function () payable {
    buyTokens(msg.sender);
  }

    // low level token purchase function
    // @notice buyTokens
    // @param beneficiary The address of the beneficiary
    // @return the transaction address and send the event as TokenPurchase
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != 0x0);
    require(validPurchase());

    uint256 weiAmount = msg.value;

   // calculate token amount to be created
    uint256 tokens = weiAmount.mul(tokenPrice);
    uint256 timebasedBonus = tokens.mul(getTimebasedBonusRate()).div(100);
    tokens = tokens.add(timebasedBonus);
     if(stage == Stage.PRESALE){
         assert(_soldPresalecap < _presale);
        soldPresalecap = soldPresalecap.add(tokens);
        
    }
    else if(stage == Stage.TOKENSALE){
         assert(_soldTokensalecap < _tokensaleCap);
        soldTokensalecap = soldTokensalecap.add(tokens);
    }
    forwardFunds();
    balances[tokenOwner] = balances[tokenOwner].sub(tokens);
    balances[beneficiary] = balances[beneficiary].add(tokens);
    // update state
    fundRaised = fundRaised.add(weiAmount);
    
    
   // investedAddressandAmounts[beneficiary] = weiAmount;
    //indexes = indexes.add(1);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
  }
  
   // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
        tokenOwner.transfer(msg.value);
  }
   

    // What is the balance of a particular account?
    // @param who The address of the particular account
    // @return the balanace the particular account
    function balanceOf(address _to) public constant returns (uint256) {
        return balances[_to];
    }

    // @notice send `value` token to `to` from `msg.sender`
    // @param to The address of the recipient
    // @param value The amount of token to be transferred
    // @return the transaction address and send the event as Transfer
    function transfer(address to, uint256 value) public {
        require (
            balances[msg.sender] >= value && value > 0
        );
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        Transfer(msg.sender, to, value);
    }


    // @notice send `value` token to `to` from `from`
    // @param from The address of the sender
    // @param to The address of the recipient
    // @param value The amount of token to be transferred
    // @return the transaction address and send the event as Transfer
    function transferFrom(address from, address to, uint256 value) public onlyOwner {
        require (
            balances[from] >= value && value > 0
        );
        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        
        Transfer(from, to, value);
    }

    // Allow spender to withdraw from your account, multiple times, up to the value amount.
    // If this function is called again it overwrites the current allowance with value.
    // @param spender The address of the sender
    // @param value The amount to be approved
    // @return the transaction address and send the event as Approval
    function approve(address spender, uint256 value) public {
        require (
            balances[msg.sender] >= value && value > 0
        );
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
    }

    // Check the allowed value for the spender to withdraw from owner
    // @param owner The address of the owner
    // @param spender The address of the spender
    // @return the amount which spender is still allowed to withdraw from owner
    function allowance(address _owner, address spender) public constant returns (uint256) {
        return allowed[_owner][spender];
    }

    // Get current price of a Token
    // @return the price or token value for a ether
    function getPrice() public constant returns (uint256 result) {
        return tokenPrice;
    }

    // @return true if crowdsale current lot event has ended
    function hasEnded() public constant returns (bool) {
        return getNow() > endTime;
    }
     // @return  current time
    function getNow() public constant returns (uint) {
        return (now * 1000);
    }
  
  // @return true if the transaction can buy tokens
  function validPurchase() internal constant returns (bool) {
        bool withinPeriod = getNow() >= startTime && getNow() <= endTime;
        bool nonZeroPurchase = msg.value != 0;
        bool minContribution = minContribAmount <= msg.value;
        return withinPeriod && nonZeroPurchase && minContribution;
    }

  // Get the time-based bonus rate
  function getTimebasedBonusRate() internal constant returns (uint256) {
  	uint256 bonusRate = 0;
      if (stage == Stage.PRESALE) {
          bonusRate = 50;
      } else {
          uint256 nowTime = now;
          uint256 week1 = startTime + (48 hours);
          uint256 week2 = startTime + (7 days);
          uint256 week3 = startTime + (14 days);
          uint256 week4 = startTime + (21 days);
          if (nowTime <= week1) {
              bonusRate = 25;
          } else if (nowTime <= week2) {
              bonusRate = 20;
          } else if (nowTime <= week3) {
              bonusRate = 10;
          } else if (nowTime <= week4) {
              bonusRate = 5;
          }
      }
      return bonusRate;
  }

  // Updated Next lot cap and start and end date
  function startCrowdsale(uint256 startTime, uint256 endTime) onlyOwner {
      require(hasEnded());
      require(_startTime >= now);
      require(_endTime >= _startTime);
     
      stage = Stage.TOKENSALE;
      startTime = _startTime;
      endTime = _endTime;
      minContribAmount = 0.5 ether;
  }
  //crowdsale end stage and this is final stage 
   function endCrowdsale() public onlyOwner{
      require(stage == Stage.TOKENSALE && hasEnded());
      stage = Stage.FINISH;

   }
   // @return true if the crowdsale has raised Maximun money to be successful.
    function isMaximumGoalReached() public constant returns (bool reached) {
        return fundRaised >= hardCap;
    }
     // @return true if the crowdsale has raised Maximun money to be successful.
    function isMinimumGoalReached() public constant returns (bool reached) {
        return fundRaised >= softCap;
    }
     function teamtokenAllocation(address to, uint256 value) onlyOwner {
         require (
            to != 0x0 && value > 0 && teamAllocation >= value
         );
         balances[tokenOwner] = balances[tokenOwner].sub(value);

         balances[to] = balances[to].add(value);

         teamAllocation = teamAllocation.sub(value);
	       Transfer(msg.sender, to, value);
     }

     function marketallocationTokens(address to, uint256 value) onlyOwner {
         require (
            to != 0x0 && value > 0 && marketallocation>= value
         );
         balances[tokenOwner] = balances[tokenOwner].sub(value);
         balances[to] = balances[to].add(value);

         marketallocation = marketallocation.sub(value);
	     Transfer(msg.sender, to, value);
     }
   
}
