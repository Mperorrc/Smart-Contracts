// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "/contracts/erc20token.sol";

contract ProductMarket {
    
    struct Product {
        uint256 id;
        string name;
        uint256 price;
    }

    struct Purchase {
        address buyer;
        uint256 productId;
    }

    DiscountToken token;

    address constant public companyABC = 0xc88050a842054ed74862F5bbEF0a247ac031C057;

    mapping(uint256 => Product) products;
    mapping(address => uint256) tempWallet;

    uint256 productCount;

    event EtherTransferred(address indexed from, address indexed to, uint256 amount);
    event LogMessage(uint256 message);
    event SentToCompanyABC(uint256 amount);
    event Refunded(address receiver, uint256 amount);
    event Failed(string message);
    event Received(address sender, uint256 amount);

    constructor(address _contractAddress) {
        token = DiscountToken(_contractAddress);
        productCount = 0;
        addProduct("Product 1", 0.01 ether);
        addProduct("Product 2", 0.015 ether);
        addProduct("Product 3", 0.02 ether);
        addProduct("Product 4", 0.012 ether);
        addProduct("Product 5", 0.018 ether);
    }

    function addProduct(string memory _name, uint256 _price) private {
        products[productCount] = Product(productCount, _name, _price);
        productCount++;
    }
    
    function buyProduct(uint256 _productId,address acc) public{
        require(_productId >= 0 && _productId <= productCount, "Invalid product ID");
        require(acc!=companyABC,"The Company account is not meant to buy products.");
        uint256 tokenCount=getTokenBalance(acc);
        uint256 discountedPrice = getDiscount(products[_productId].price,tokenCount,acc);
        emit LogMessage(discountedPrice);
        uint256 balance = getBalance(acc);
        require(discountedPrice<=balance,"Insufficient Funds");
        payable(companyABC).transfer(discountedPrice);
        tempWallet[acc]-=discountedPrice;
        if(getBalance(companyABC)>0){
            token.mintOne();     
        }
        // token.transferToUser(acc,1*(10**18));
        emit SentToCompanyABC(discountedPrice);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);        
        tempWallet[msg.sender]+=msg.value;
    }

    function getBalance(address add) public view returns(uint256){
        return tempWallet[add];
    }

    function getTokenBalance(address add) public view returns(uint256){
        return token.balanceOf(add);
    }

    function getDiscount(uint _price,uint256 _tokenCount,address acc) private returns(uint discount){
        if(_tokenCount>=50){
            _price = _price/2;
            token.transferBetweenAccounts(acc, companyABC, 50*(10**18));
        }
        else if(_tokenCount>=20){
            _price = _price*3/4;
            token.transferBetweenAccounts(acc, companyABC, 20*(10**18));
        }
        else if(_tokenCount>=10){
            _price = _price*9/10;
            token.transferBetweenAccounts(acc, companyABC, 10*(10**18));
        }
        return _price;
    }

    function getProducts() public view returns (Product[] memory){
        Product[] memory displayProducts = new Product[](productCount);
        for (uint i = 0; i < productCount; i++) {
            displayProducts[i] = products[i];
        }
        return displayProducts;
    }

    function withdraw(address acc) public{
        emit Refunded(acc, tempWallet[acc]);
        payable(acc).transfer(tempWallet[acc]);
        tempWallet[acc]=0;
    }
}









