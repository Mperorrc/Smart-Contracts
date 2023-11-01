// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract XYZToken is ERC20 {
    address public owner;
    uint256 public initialSupply;

    constructor(uint256 _initialSupply) ERC20("XYZ Token", "XYZ") {
        owner = msg.sender;
        initialSupply = _initialSupply * 10 ** uint256(decimals());
        _mint(msg.sender, initialSupply);
        //approve(msg.sender, initialSupply);
    }
    function approveSpender(address spender, uint256 value) public returns (bool){
        require(msg.sender == owner, "Only owner can approve spenders");
        approve(spender, value);
        return true;
    }
    function burn(address x, uint256 amount) public {
        _burn(x, amount);
    }

    function validatePurchase(uint256 purchaseAmount,uint256 numberofTokens, uint256 userTokens) external pure returns (bool) {
        // Set a maximum purchase amount limit
        uint256 maxPurchaseAmount = 100; // Adjust this as needed
        uint256 minPurchaseAmount = 1;
        // Check if the purchase amount doesn't exceed the limit
        require(purchaseAmount>=minPurchaseAmount,"Invalid purchase: Purchase amount not sufficient");
        require(purchaseAmount <= maxPurchaseAmount, "Invalid purchase: Purchase amount exceeds the limit");
        require(numberofTokens<=userTokens,"Invalid purchase: Insufficient number of tokens");
        return true; // If all validation checks pass
    }

}