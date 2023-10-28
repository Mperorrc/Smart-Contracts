// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

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

    mapping(uint256 => Product) products;
    mapping(address => Purchase[]) clientPurchases;

    uint256 productCount;

    event ProductPurchased(address buyer, uint256 productId);

    constructor() {
        productCount = 0;
        addProduct("Product 1", 100);
        addProduct("Product 2", 150);
        addProduct("Product 3", 200);
        addProduct("Product 4", 120);
        addProduct("Product 5", 180);
    }

    function addProduct(string memory _name, uint256 _price) private {
        productCount++;
        products[productCount] = Product(productCount, _name, _price);
    }

    function buyProduct(uint256 _productId) payable public {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");

        uint price = products[_productId].price;
        uint discount = getDiscount(price);
        price-=discount;

        require(msg.value >= price, "Insufficient funds");
        clientPurchases[msg.sender].push(Purchase(msg.sender, _productId));
        emit ProductPurchased(msg.sender, _productId);
    }

    function getDiscount(uint price) private view returns(uint discount){
        if(clientPurchases[msg.sender].length>=50){
            return price/2;
            
        }
        if(clientPurchases[msg.sender].length>=20){
            return price*3/4;
        }
        if(clientPurchases[msg.sender].length>=10){
            return price*9/10;
        }
        return 0;
    }

    function getClientPurchases(address _clientAddress) public view returns (Purchase[] memory) {
        return clientPurchases[_clientAddress];
    }

    // function getProducts() public view returns (Product[] memory){

    // }
}



// contract Storage{
    
//     struct Client {
//         address clientAddress;
//         string name;
//         uint balance;
//     }

//     mapping(address => Client) public clients;

//     struct Product{
//         string name;
//         uint price;
//     }

//     mapping(address => Client) public clients;

//     function addClient(string memory _name, uint _initialBalance) public {
//         require(!isClient(msg.sender), "Address already exists as a client");
//         Client memory newClient = Client(msg.sender, _name, _initialBalance);
//         clients.push(newClient);
//     }

//     function isClient(address _clientAddress) internal view returns (bool) {
//         for (uint i = 0; i < clients.length; i++) {
//             if (clients[i].clientAddress == _clientAddress) {
//                 return true;
//             }
//         }
//         return false;
//     }

//     function getClients() public view returns (Client[] memory){
//         return clients;
//     }

//     function getProducts() public view returns (Product[] memory){

//     }

// }







