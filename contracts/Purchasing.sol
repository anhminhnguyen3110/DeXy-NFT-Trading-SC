// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;

contract Purchasing {
    event TransactionAccepted(uint32 transactionId, uint32 item, address buyer, address owner);
    struct TransactionDetails {
        address from;
        address to;
        uint32 product;
        uint256 price;
        uint256 timestamp;
    }
    mapping(uint32 => TransactionDetails) private transactions;
    uint32 private transactionId;

    constructor() {
        transactionId = 0;
    }

    function getTransactionId() internal returns (uint32) {
        return transactionId++;
    }

    function handleTransaction(
        address owner,
        address buyer,
        uint32 product,
        uint256 price
    ) internal {
        address payable owner_payable = payable(owner);
        owner_payable.transfer(price);

        uint32 _transactionId = getTransactionId();

        transactions[_transactionId] = TransactionDetails(
            buyer,
            owner,
            product,
            price,
            block.timestamp
        );

        emit TransactionAccepted(_transactionId, product, buyer, owner);
    }

    function buy(address owner, uint32 product, uint256 price) public payable {
        require(msg.value == price, "Insufficient funds");

        handleTransaction(owner, msg.sender, product, price);
    }

    function batchBuy(
        address[] memory owners,
        uint32[] memory products,
        uint256[] memory prices
    ) public payable {
        require(
            owners.length == products.length && owners.length == prices.length,
            "Invalid input"
        );

        uint256 total = 0;
        for (uint i = 0; i < prices.length; i++) {
            total += prices[i];
        }
        require(msg.value == total, "Insufficient funds");

        for (uint i = 0; i < owners.length; i++) {
            handleTransaction(owners[i], msg.sender, products[i], prices[i]);
        }
    }

    function getTransactions(
        uint32[] memory transactionsIds
    ) public view returns (TransactionDetails[] memory transactionList) {
        uint32 size = 0;
        for (uint i = 0; i < transactionsIds.length; i++) {
            if (transactions[transactionsIds[i]].from != address(0)) size++;
        }

        transactionList = new TransactionDetails[](size);
        uint32 cur_idx = 0;
        for (uint i = 0; i < transactionsIds.length; i++) {
            if (transactions[transactionsIds[i]].from != address(0))
                transactionList[cur_idx++] = transactions[transactionsIds[i]];
        }
        return transactionList;
    }
}
