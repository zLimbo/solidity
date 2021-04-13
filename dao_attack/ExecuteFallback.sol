// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract ExecuteFallback {
    
    //回退事件，会把调用的数据打印出来
    event FallbackCalled(bytes data);

    //fallback函数，注意是没有名字的，没有参数，没有返回值的
    int x;
    
    fallback() external payable {
        emit FallbackCalled(msg.data);
    }

    //调用已存在函数的事件，会把调用的原始数据，请求参数打印出来
    event ExistFuncCalled(bytes data, uint256 para);

    //一个存在的函数
    function existFunc(uint256 para) public payable {
        emit ExistFuncCalled(msg.data, para);
    }

    // 模拟从外部对一个存在的函数发起一个调用，将直接调用函数
    function callExistFunc() public {
        bytes4 funcIdentifier = bytes4(keccak256("existFunc(uint256)"));
        address(this).call(abi.encode(funcIdentifier, uint256(1)));
    }

    //模拟从外部对一个不存在的函数发起一个调用，由于匹配不到函数，将调用回退函数
    function callNonExistFunc() public payable {
        bytes4 funcIdentifier = bytes4(keccak256("functionNotExist()"));
        address(this).call(abi.encode(funcIdentifier));
    }
}
