import sys
import getopt


def main(argv):
    playername = ''
    try:
        opts, args = getopt.getopt(argv, "hp:", ["help", "playername="])
    except:
        print('Error: aeroplane_chess.py -p <playername>')
        print('   or: aeroplane_chess.py --playername=<playername>')
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            print('Error: aeroplane_chess.py -p <playername>')
            print('   or: aeroplane_chess.py --playername=<playername>')
            sys.exit()
        elif opt in ('-p', '--playername'):
            playername = arg
    print('player name: ', playername)
    for i in range(0, len(args)):
        print('参数 %s 为：%s' % (i + 1, args[i]))


if __name__ == '__main__':
    main(sys.argv[1:])


from web3 import Web3
w3 = Web3(Web3.HTTPProvider("http://localhost:7545"))
w3.isConnected()
eth = w3