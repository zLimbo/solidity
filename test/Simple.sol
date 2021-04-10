// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract Simple {

    uint data;

    function set(uint _data) public {
        data = _data;
    }

    function add(uint x) public {
        data += x;
    }

    function get() public view returns (uint) {
        return data;
    }

    function hash(string memory str) public pure returns (uint) {
        uint res = uin(keccak256.(abi.encodePacked(str)));
        return res;
    }
}

