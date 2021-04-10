#include <iostream>
#include <unordered_map>
#include <assert.h>

using namespace std;

using address = string;
using uint = unsigned int;
#define mapping(K, V) unordered_map<K, V>

// struct Player {
//     address addr;
//     string name;
//     uint position;
//     int direction;

//     Player(address _addr, string _name, uint _position, int _direction):
//         addr(_addr), name(_name), position(_position), direction(_direction) {}
// };

// class AeroplaneChess {

// private:
//     uint destination;
//     uint dice;
//     bool gameover;
//     Player winner;
//     uint count;

//     mapping(uint, Player) players;
//     mapping(address, uint) playerId;
//     mapping(string, bool) used;
//     mapping(address, bool) isPlay;

// public:
//     AeroplaneChess(uint _destination, uint _dice) {
//         assert(_destination > 0 && _dice > 0);
//         destination = _destination;
//         dice = _dice;
//         count = 0;
//         gameover = false;
//     }

//     uint randDice() {
//         return rand() % dice;
//     }

//     void join(string _name) {
//         address addr = _name;
//         assert(!isPlay[addr]);
//         isPlay[addr] = true;
//         players[count] = Player(addr, _name, 0, 1);
//         ++count;

//     }

//     void play(string _str) {
        
//     }
// };



int main() {
    uint target = 100;
    uint dice = 6;

    cin >> target >> dice;
    uint pos = 0;
    int dir = 1;

    while (pos != target) {
        uint step = rand() % dice;
        int npos = int(pos) + dir * int(step);

        while (true) {
            if (npos < 0) {
                npos = -npos;
                dir = 1;
            } else if (uint(npos) > target) {
                npos = int(target) * 2 - npos;
                dir = -1;
            } else {
                break;
            }
        }

        printf("pos: %d\tdir: %d\tstep: %d\tnpos: %d\n", pos, dir, step, npos);
        pos = npos;
    }
    
    return 0;
}