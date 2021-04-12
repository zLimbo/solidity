// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0; // 编译指令，指明solidity版本，上面一行是自由软件许可证

contract HelloWorld3 {

    // 状态变量，存储于以太坊中
    string greeting; 

    // 事件，更新变量
    event Update(string old_value, string new_value);

    // 构造函数，部署合约时调用
    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    // 函数， view 关键字告诉编译器该函数仅读但不写状态变量
    function say() public view returns (string memory) {
        return greeting;
    }

    // 更新状态变量
    function update(string memory _greeting) public {
        string memory old_value = greeting;
        string memory new_value = _greeting;
        greeting = _greeting;
        emit Update(old_value, new_value);
    }
}

