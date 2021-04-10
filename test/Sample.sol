// SPDX-License-Identifier: GPL-3.0 
pragma solidity >=0.4.16 <0.9.0; // 编译指令，指明solidity版本，上面一行是自由软件许可证

contract Sample{   // 合约

    //State variables, 状态变量，存储于以太坊区块链中
    address private _admin;  
    uint private _state;

    //Modifier, 函数修饰，类似于Python中的装饰器
    modifier onlyAdmin(){
        require(msg.sender == _admin, "You are not admin");  // 检查    
        _; // 执行修饰的函数
    }

    //Events, 事件，通知链外发生了什么事，被记录在Receipt中的log中，相当于代码的打印信息
    event SetState(uint value);

    //Constructor，构造器，即构造函数，合约部署时执行的代码
    constructor() {
        _admin = msg.sender; // 部署时就确定了管理员为部署的账户
    }

    //Functions，会改变合约状态的函数，函数修饰器
    function setState(uint value) public onlyAdmin{
        _state = value;
        emit SetState(value);
    }

    // view 关键字, 只读合约状态的函数
    function getValue() public view returns (uint){
        return _state;
    }
}

