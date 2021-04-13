from web3 import Web3
import os
import sys
import getopt
import uuid

# url = "http://localhost:7545"   # 以太坊测试链 rpc 连接端口
url = "http://192.168.6.104:7545"
contract_address_file = 'contract_address.txt'  # 合约地址保存文件
abi_file = "AeroplaneChess/AeroplaneChess.abi"  # abi 文件
bytecode_file = "AeroplaneChess/AeroplaneChess.bin"  # 字节码文件

# 连接测试链
w3 = Web3(Web3.HTTPProvider(url))   
eth = w3.eth
print("eth connect:", w3.isConnected())


destination = 20   # 目的地位置
dice = 6    # 骰子
player_name = ''
account_id = -1


def set_default_account():
    """
        设置调用合约、发送交易的账户
    """
    global account_id
    eth.defaultAccount = eth.accounts[account_id]


def log_param_error():
    """
        打印错误信息
    """
    print('Error: aeroplane_chess.py -n <name> -i <id>')
    print('   or: aeroplane_chess.py --name=<name> --id=<id>')


def init_player(argv):
    """
        解析命令行参数，设置游戏玩家姓名和以太坊账户id
    """
    global player_name
    global account_id
    try:
        opts, args = getopt.getopt(argv, "hn:i:", ["help", "name=", "id="])
    except:
        log_param_error()
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            log_param_error()
            sys.exit()
        elif opt in ('-n', '--name'):
            player_name = arg
        elif opt in ('-i', '--id'):
            account_id = int(arg)
    print("name:", player_name)
    if not player_name or account_id < 0:
        log_param_error()
        sys.exit(2)


def get_abi_from_file(file):
    """
       从文件中获取abi
    """
    with open(file, 'r') as f:
        return f.read() 


def get_bytecode_from_file(file):
    """
        从文件中获取字节码
    """
    with open(file, 'r') as f:
        return "0x" + f.read()


# def read_file(file):
#     """
#         从文件中读取所有内容
#     """
#     with open(file, 'w') as f:
#         return f.read()


def deploy_contract(abi, bytecode):
    """
        部署合约
    """
    contract = eth.contract(abi=abi, bytecode=bytecode) # 创建合约
    tx_hash = contract.constructor(destination, dice).transact() # 部署合约（发送构造函数的交易，需相对应合约中的参数）
    tx_receipt = eth.waitForTransactionReceipt(tx_hash) # 等待交易回执
    print("contract address:", tx_receipt.contractAddress) # 合约地址
    # 保存合约
    global contract_address_file
    with open(contract_address_file, "w") as f:
        f.write(tx_receipt.contractAddress)
    # 通过地址获取已部署合约
    deployed_contract = eth.contract(address=tx_receipt.contractAddress, abi=abi)
    return deployed_contract


def get_deployed_contract(abi, bytecode):
    """
        获取部署合约，如果本地已保存合约地址，则调用该地址的合约，否则重新创建一个新的合约
    """
    try:
        # 尝试获取已有合约
        with open(contract_address_file, "r") as f:
            contract_address = f.read()
        print("contract address:", contract_address)
        deployed_contract = eth.contract(address=contract_address, abi=abi)
        return deployed_contract
    except IOError:
        # 获取已有合约失败则重新部署新合约
        return deploy_contract(abi, bytecode)


def show_global_status(deployed_contract):
    """
        打印棋盘和所有参与者的状态
    """
    global destination
    board = [[] for _ in range(destination + 1)]
    players = deployed_contract.functions.getPlayers().call() # 获取所有玩家状态
    for player in players:
        board[player[2]].append(player)
    # 打印棋盘
    print('-' * 20 + 'game board' + '-' * 20)
    for idx in range(len(board)):
        print(idx, ':', end=' ')
        for player in board[idx]:
            name, direction, step, round = player[1], player[3], player[4], player[5]
            # 使用符号表示当前玩家向上还是向下
            print('[', name, ('V' if direction == 1 else '^') + str(step), 'r' + str(round), ']', end = ' ')
        print()
    print('-' * 20 + 'game board' + '-' * 20)
    # 打印所有玩家状态
    # print("all player status:")
    # for player in players:
    #     print('\t', player)
    

def play():
    """
        进行游戏
    """
    # 获取游戏合约
    global abi_file, bytecode_file
    abi = get_abi_from_file(abi_file)
    bytecode = get_bytecode_from_file(bytecode_file)
    deployed_contract = get_deployed_contract(abi, bytecode)
    # 打印游戏信息
    game_info = deployed_contract.functions.getGameInfo().call()
    print("game info: destination={}, dice={}, gameover={}, player_num={}".
            format(game_info[0], game_info[1], bool(game_info[2]), game_info[4]))
    # 如果之前已经参加，则继续游戏，合约保存了玩家参加的状态
    if deployed_contract.functions.isJoin().call():
        player = deployed_contract.functions.getPlayer().call()
        print(player_name, "continue this game, player status:", player)
    else:
        # 否则参加游戏
        deployed_contract.functions.join(player_name).transact()
        player = deployed_contract.functions.getPlayer().call()
        print(player_name, "joined this game, player status:", player)

    # 游戏未结束就不断循环
    while not deployed_contract.functions.isOver().call():
        # 使用uuid每次生成不同的字符串作为参数，以获取随机骰子
        uuid_str = str(uuid.uuid4())
        print()
        print(player_name, "playing, input:", uuid_str)
        last_status = deployed_contract.functions.getPlayer().call()
        # 由于同步问题，可能执行到此时，已有其他玩家到达终点，游戏结束，这里会抛出异常, 故直接退出循环终止
        try:
            deployed_contract.functions.play(uuid_str).transact()
        except:
            # 输出结束状态
            show_global_status(deployed_contract)
            break
        # 打印本次执行后的状态
        deployed_contract.functions.getPlayer().transact()
        cur_status = deployed_contract.functions.getPlayer().call()
        print("round:", cur_status[5], "\trandom dice:", cur_status[4], "\tstep:", last_status[2], "->", cur_status[2])
        show_global_status(deployed_contract)
    # 打印游戏胜利者
    winner = deployed_contract.functions.getWinner().call()
    print("\ngameover! The winner is", winner)
    # show_global_status(deployed_contract)
    # 删除合约地址文件夹
    try:
        os.remove(contract_address_file)
    except:
        pass


if __name__ == '__main__':
    init_player(sys.argv[1:])
    set_default_account()
    play()