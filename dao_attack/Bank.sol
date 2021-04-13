// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract Bank {
    mapping(address => uint256) public userBalances;
    uint256 public balance; // 模拟看不见的合约账户余额

    event In(address addr, uint value);
    event Out(address addr, uint value);
    
    constructor() payable {
        balance = msg.value;
    }

    function getUserBalance(address user) public view returns (uint256) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] = userBalances[msg.sender] + msg.value;
        emit In(msg.sender, msg.value);
        balance += msg.value;
    }

    //攻击点函数所在处
    function withdrawBalance() public payable {
        uint256 amountToWithdraw = userBalances[msg.sender];
        (bool success, bytes memory returnData) = address(msg.sender).call{
            value: amountToWithdraw}(abi.encodeWithSignature("withdrawBalance()"));
        userBalances[msg.sender] = uint256(0);
        // require(success);
        emit Out(msg.sender, amountToWithdraw);
        balance -= msg.value;
    }
}
