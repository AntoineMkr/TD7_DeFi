pragma solidity >=0.4.22 <0.8.0;

contract OxYYYY{
    function claimTokens() public {}
    function approve(address spender, uint256 amount) public returns (bool) {}
    function decreaseAllowance(address spender, uint256 subtractedValue)        public        returns (bool)    {}
    function transfer(address recipient, uint256 amount)        public        returns (bool)    {}
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool){}

}

contract RouterInterface {
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns(uint amountToken, uint amountETH, uint liquidity){}
    
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH){}
}

contract OxZZZZ{
    RouterInterface Ri;
    mapping(address => uint256) public claimed;
    mapping(address => uint256) public liquidityTokens;

    address tokenAddress = 0xeE528BFfb58B26d0953e06DcA0E2D8961Ddc2Dd4;
    OxYYYY token = OxYYYY(tokenAddress);


    constructor ()public{
        Ri = RouterInterface(address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
    }

    function balanceOf(address addr) public view returns(uint256 balance){
        return claimed[addr];
    }

    //user must call approve before
    function deposit(uint256 quantity) public returns (bool status) {
        status= token.transferFrom(msg.sender, address(this), quantity);
        claimed[msg.sender] += quantity;
        return status;
    }
    function getBackTokens(uint256 quantity) public returns (bool status) {
        status = token.transfer(msg.sender, quantity);
        return status;
    }
    
    function AddLiquidity(uint amountTokenDesired)public payable returns(uint liquidityToken){
        require(claimed[msg.sender] >= amountTokenDesired, "not enough tokens");
        uint etherSend= msg.value;
        uint oxy = amountTokenDesired*10^18;
        (uint amountToken, uint amountETH, uint liquidity)= Ri.addLiquidityETH(address(0xeE528BFfb58B26d0953e06DcA0E2D8961Ddc2Dd4), oxy, oxy -200,  (0.1 ether) , msg.sender, (block.timestamp+ 10 minutes));
        claimed[msg.sender] -= amountToken;
        uint unusedEthers=etherSend-amountETH;
        msg.sender.transfer(unusedEthers);    
        liquidityTokens[msg.sender] += liquidity;
        return liquidity;
    }

    function RemoveLiquidity(uint amountLiquidityToken)public payable{
        uint oxy = amountLiquidityToken*10^18;

        require(liquidityTokens[msg.sender] >= oxy, "not enough Liquidity tokens");
        
        (uint amountToken, uint amountETH)= Ri.removeLiquidityETH(address(0xeE528BFfb58B26d0953e06DcA0E2D8961Ddc2Dd4),oxy,1,  (0.0001 ether) , msg.sender, (block.timestamp+ 10 minutes));
        claimed[msg.sender] += amountToken;
        liquidityTokens[msg.sender] -= oxy;
        msg.sender.transfer(amountETH);  
    }
}