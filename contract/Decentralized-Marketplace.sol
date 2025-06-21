// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Marketplace {
    struct Product {
        uint id;
        address payable seller;
        string name;
        uint price;
        bool isSold;
    }

    uint public productCount;
    mapping(uint => Product) public products;

    event ProductListed(uint id, address seller, string name, uint price);
    event ProductPurchased(uint id, address buyer);

    function listProduct(string memory _name, uint _price) external {
        require(_price > 0, "Price must be greater than 0");
        productCount++;
        products[productCount] = Product(productCount, payable(msg.sender), _name, _price, false);
        emit ProductListed(productCount, msg.sender, _name, _price);
    }

    function buyProduct(uint _id) external payable {
        Product storage product = products[_id];
        require(_id > 0 && _id <= productCount, "Invalid product ID");
        require(!product.isSold, "Product already sold");
        require(msg.value == product.price, "Incorrect payment amount");

        product.seller.transfer(msg.value);
        product.isSold = true;

        emit ProductPurchased(_id, msg.sender);
    }

    function getProduct(uint _id) external view returns (Product memory) {
        require(_id > 0 && _id <= productCount, "Invalid product ID");
        return products[_id];
    }
}
