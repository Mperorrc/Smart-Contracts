// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// import "/contracts/erc20token.sol";

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

    address constant public companyABC = 0xc88050a842054ed74862F5bbEF0a247ac031C057;

    mapping(uint256 => Product) products;
    mapping(address => uint256) clientTokens;

    uint256 productCount;

    event EtherTransferred(address indexed from, address indexed to, uint256 amount);
    event LogMessage(uint256 message);
    event Received(address sender, uint256 amount);
    event SentToCompanyABC(uint256 amount);
    event Refunded(address receiver, uint256 amount);

    constructor() {
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

    function buyProduct(uint256 _productId) public returns(uint256) {
        require(_productId >= 0 && _productId <= productCount, "Invalid product ID");
        require(msg.sender!=companyABC,"The Company account is not meant to buy products.");
        uint256 tokenCount=0;
        uint256 discountedPrice = getDiscount(products[_productId].price,tokenCount);
        
        emit LogMessage(discountedPrice);
        uint256 balance = getBalance();
        if(discountedPrice<=balance){
            uint256 excessAmount = balance - discountedPrice;
            // Transfer the excess amount back to the sender
            if (excessAmount > 0) {
                payable(msg.sender).transfer(excessAmount);
                emit Refunded(msg.sender, excessAmount);
            }
            // Transfer the accepted amount to COMPANYABC
            payable(companyABC).transfer(discountedPrice);
            emit SentToCompanyABC(discountedPrice);
        }
        else{
            payable(msg.sender).transfer(balance);
            emit Refunded(msg.sender, balance);       
        }

        return discountedPrice;    
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);        
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function getDiscount(uint _price,uint256 _tokenCount) private returns(uint discount){
        if(_tokenCount>=50){
            _price = _price/2;
            clientTokens[msg.sender]-=50;
        }
        if(_tokenCount>=20){
            _price = _price*3/4;
            clientTokens[msg.sender]-=20;
        }
        if(_tokenCount>=10){
            _price = _price*9/10;
            clientTokens[msg.sender]-=10;
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
}









