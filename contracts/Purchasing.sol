// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;

contract Purchasing {
    event TransactionAccepted(uint32 transactionId, address buyer, address owner);
    struct TransactionDetails {
        address from;
        address to;
        uint32 product;
        uint256 price;
    }
    mapping(uint32 => TransactionDetails) public transactions;
    uint32 private transactionId;

    constructor() {
        transactionId = 0;
    }

    function getTransactionId() internal returns (uint32) {
        return transactionId++;
    }

    function buy(address owner, uint32 product, uint256 price) public payable {
        require(msg.value == price, "Insufficient funds");

        address payable owner_payable = payable(owner);
        owner_payable.transfer(msg.value);

        uint32 _transactionId = getTransactionId();

        transactions[_transactionId] = TransactionDetails(msg.sender, owner, product, price);

        emit TransactionAccepted(_transactionId, msg.sender, owner);
    }

    function getTransactions(
        uint32[] memory transactionsIds
    ) public view returns (TransactionDetails[] memory transactionList) {
        transactionList = new TransactionDetails[](transactionsIds.length);
        for (uint i = 0; i < transactionsIds.length; i++) {
            transactionList[i] = transactions[transactionsIds[i]];
        }
        return transactionList;
    }
}
