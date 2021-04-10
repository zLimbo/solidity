// SPDX-License-Identifier: GPL-3.0 
pragma solidity >=0.4.16 <0.9.0; // 编译指令，指明solidity版本，上面一行是自由软件许可证

// 合约
contract AeroplaneChess {   

    // 玩家结构体
    struct Player {
        address addr;   
        string name;
        uint position;
        int direction;  // 方向
        uint step;  // 当前轮走的步数
        uint round; // 轮次，第几次走
    }

    uint destination; 
    uint dice;
    bool gameover;
    uint winnerId;
    uint num;   // 玩家数目
    Player[] players;
    mapping(address => uint) playerId;  // 地址到id的映射
    mapping(address => bool) isPlay;    // 是否参与游戏
    
    // 构造器
    constructor(uint _destination, uint _dice) {
        require(_destination > 0 && _dice > 0);
        destination = _destination;
        dice = _dice;
        num = 0;
        gameover = false;
    }

    function isOver() public view returns (bool over) {
        return gameover;
    }

    function getWinner() public view returns (Player memory) {
        require(gameover);
        return players[winnerId];
    }

    function getGameInfo() public view returns (uint, uint, bool, uint, uint) {
        return (destination, dice, gameover, winnerId, num);
    }

    function getPlayers() public view returns (Player[] memory) {
        return players;
    }

    // 获取当前以太坊账户的参与账号
    function getPlayer() public view returns (Player memory) {
        require(isPlay[msg.sender]);
        uint id = playerId[msg.sender];
        return players[id];
    }

    // 是否参加了游戏，遍历玩家数组
    function isJoin() public view returns (bool) {
        bool ret = false;
        for (uint i = 0; i < num; ++i) {
            if (players[i].addr == msg.sender) {
                ret = true;
                break;
            }
        }
        return ret;
    }

    // 参加游戏
    function join(string memory _name) public {
        require(!isPlay[msg.sender]);
        isPlay[msg.sender] = true;
        // 数组添加一个用户, 后面四个数字依次为：初始位置，方向，当前骰子步数，轮次
        players.push(Player(msg.sender, _name, 0, 1, 0, 0));   
        playerId[msg.sender] = num;
        num += 1;
    }

    // 随机骰子 [1, dice]
    function randomDice(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % uint(dice) + 1;
    }

    // 进行游戏，字符串作为随机值参数
    function play(string memory _str) public {
        require(isPlay[msg.sender]);
        require(!gameover);

        uint step = randomDice(_str);
        uint id = playerId[msg.sender];
        int newPosition = int(players[id].position) + players[id].direction * int(step);
        
        while (true) {
            if (newPosition < 0) {
                newPosition = -newPosition;
                players[id].direction = 1;
            } else if (uint(newPosition) > destination) {
                newPosition = int(destination) * 2 - newPosition;
                players[id].direction = -1;
            } else {
                break;
            }
        }
        
        players[id].position = uint(newPosition);
        players[id].step = step;
        players[id].round += 1;

        if (uint(newPosition) == destination) {
            // success
            gameover = true;
            winnerId = id;
            return;
        }

        for (uint i = 0; i < num; ++i) {
            if (i != id && players[i].position == uint(newPosition)) {
                players[i].position = 0;
            }
        }
    }
}