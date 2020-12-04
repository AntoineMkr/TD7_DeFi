pragma solidity >=0.4.22 <0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DepositorToken is ERC20{

    constructor() ERC20("0xYYYY", "OxY") public{
        _mint(msg.sender, 12000000);
    }


}