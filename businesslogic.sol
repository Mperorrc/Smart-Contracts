// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token.sol";

contract XYZBusinessLogic {
    address public owner;
    XYZToken public tokenContract;
    uint256 public discountPercentage;
    mapping(uint256 => uint256) public tokenToDiscount;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor(address _tokenAddress) payable {
        owner = msg.sender;
        tokenContract = XYZToken(_tokenAddress);
        tokenToDiscount[10] = 5; // For 10 tokens, a 5% discount
        tokenToDiscount[20] = 10; // For 20 tokens, a 10% discount
        tokenToDiscount[40] = 15; // For 50 tokens, a 15% discount
    }

    receive() external payable {}

    function purchaseProduct(
        uint256 amount,
        uint256 numberofTokens
    ) public payable {
        tokenContract.validatePurchase(
            amount,
            numberofTokens,
            tokenContract.balanceOf(msg.sender)
        );
        if (numberofTokens >= 10) {
            uint256 userTokens = tokenContract.balanceOf(msg.sender);

            uint256 canUseTokens = 0;

            if (userTokens >= 40) {
                canUseTokens = 40;
            } else if (userTokens >= 20 && userTokens < 40) {
                canUseTokens = 20;
            } else {
                canUseTokens = 10;
            }
            discountPercentage = tokenToDiscount[canUseTokens];

            uint256 discount = amount * (discountPercentage / 100);
            amount -= discount;
            tokenContract.burn(msg.sender, canUseTokens);
        }

        require(amount <= msg.sender.balance, "Insufficient Funds");

        // Transfer the purchase amount to the owner's address
        address payable ownerAddress = payable(owner);
        ownerAddress.transfer(amount);

        tokenContract.approve(address(this), 5);
        tokenContract.transferFrom(owner, msg.sender, 5);
    }

    function getCustomerTokenBalance() external view returns (uint256) {
        return tokenContract.balanceOf(msg.sender);
    }

    function getCustomerBalance() external view returns (uint256) {
        return msg.sender.balance;
    }

    function getOwnerBalance() external view returns (uint256) {
        return owner.balance;
    }

    function getAllowance() external view returns (uint256) {
        return tokenContract.allowance(owner, address(this));
    }
}
