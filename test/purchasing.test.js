const Purchasing = artifacts.require("Purchasing");

contract("Purchasing", (accounts) => {
  it("should process transaction correctly", async () => {
    const purchasingInstance = await Purchasing.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = await web3.eth.getBalance(accountOne);
    const accountTwoStartingBalance = await web3.eth.getBalance(accountTwo);

    // Make transaction from first account to second with value of 10 ether
    const amount = web3.utils.toWei("2", "ether");
    const result = await purchasingInstance.buy(accountTwo, "123", amount, {
      from: accountOne,
      value: amount,
    });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = await web3.eth.getBalance(accountOne);
    const accountTwoEndingBalance = await web3.eth.getBalance(accountTwo);

    // check if accountone balance is correct taken all fees into account
    assert.isTrue(
      parseInt(accountOneEndingBalance) <=
        parseInt(accountOneStartingBalance) - parseInt(amount),
      "Amount wasn't correctly taken from the sender"
    );
    assert.equal(
      accountTwoEndingBalance,
      parseInt(accountTwoStartingBalance) + parseInt(amount),
      "Amount wasn't correctly sent to the receiver"
    );
  });
});
