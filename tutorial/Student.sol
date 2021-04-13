// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0; // 编译指令，指明solidity版本，上面一行是自由软件许可证

contract StudentContract {
    
    struct Student {
        int id;
        string name;
        bool graduated;
    }
    
    Student[] students;

    function insert(int _id, string _name, bool _graduated) public return (bool) {
        // TODO
    }

    function delete(int _id) public returns (bool) {
        // TODO
    }

    function update(int _id, string _newName) public returns (bool) {
        // TODO
    }

    function select(int _id) public view returns (Student) {
        // TODO
    }

    // 更多自定义的函数接口
}

