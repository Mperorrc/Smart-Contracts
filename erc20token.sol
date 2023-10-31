// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract DiscountToken is ERC20 {
    uint256 tokensLeft = 0;

    constructor() ERC20("Discount Tokens", "DTK") {
        mintOne();
    }

    function mintOne() public {
        _mint(msg.sender, 1*(10**18));
    }

    function transferToUser(address _to,uint256 value) public {
        transfer(_to, value);
    }

    function transferBetweenAccounts(address _from,address _to,uint256 value) public{
        transferFrom(_from,_to,value);
    }

}
