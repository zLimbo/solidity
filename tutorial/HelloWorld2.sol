// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0; // 编译指令，指明solidity版本，上面一行是自由软件许可证

contract HelloWorld2 {

    // 状态变量，存储于以太坊中
    string greeting = "Hello world!";   

    // 函数， view 关键字告诉编译器该函数仅读但不写状态变量
    function say() public view returns (string memory) {
        return greeting;
    }

    // 修改状态变量
    function set(string memory _greeting) public {
        greeting = _greeting;
    }
}

