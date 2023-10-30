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

    address constant public companyABC = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;

    mapping(uint256 => Product) products;
    mapping(address => Purchase[]) clientPurchases;
    mapping(address => uint256) clientTokens;

    uint256 productCount;

    event EtherTransferred(address indexed from, address indexed to, uint256 amount);
    event LogMessage(uint256 message);

    constructor() {
        productCount = 0;
        addProduct("Product 1", 100);
        addProduct("Product 2", 150);
        addProduct("Product 3", 200);
        addProduct("Product 4", 120);
        addProduct("Product 5", 180);
    }

    function addProduct(string memory _name, uint256 _price) private {
        products[productCount] = Product(productCount, _name, _price);
        productCount++;
    }

    function buyProduct(uint256 _productId) public returns(uint256) {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        require(msg.sender!=companyABC,"The Company account is not meant to buy products.");
        uint256 tokenCount=0;
        uint256 discountedPrice = getDiscount(products[_productId].price,tokenCount);
        emit LogMessage(discountedPrice*(10**16));
        // uint256 accBalance = getBalance();
        // emit LogMessage(accBalance);
        // require(accBalance >= discountedPrice, "Insufficient funds");
        // bool success = _sendEther(discountedPrice*(10**16));
        // emit LogMessage(discountedPrice);
        return discountedPrice;    
    }



    function _sendEther(uint256 amount) internal returns(bool){
        require(amount > 0, "Value must be greater than 0");

        (bool success, ) = payable(companyABC).call{value: amount}("");
        require(success, "Purchase failed");    
        emit EtherTransferred(address(this), companyABC, amount);
        return success;
    }

    function getBalance() private view returns(uint256){
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

    function getClientPurchases(address _clientAddress) public view returns (Purchase[] memory) {
        return clientPurchases[_clientAddress];
    }

    function getProducts() public view returns (Product[] memory){
        Product[] memory displayProducts = new Product[](productCount);
        for (uint i = 0; i < productCount; i++) {
            displayProducts[i] = products[i];
        }
        return displayProducts;
    }
}









