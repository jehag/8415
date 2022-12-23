import random
import pymysql

from sshtunnel import SSHTunnelForwarder
from pythonping import ping

subordinates = [ 
    { 
        "name": "subordinate1", 
        "ipAddress": '137.31.1.2'
    }, 
    { 
        "name": "subordinate2", 
        "ipAddress": '137.31.1.3'
    }, 
    { 
        "name": "subordinate3", 
        "ipAddress": '137.31.1.4'
    }
]

def executeQuery(query, target):
    print("executing node : " + target)

    tunnel = ""
    if target != "master":
        tunnel = SSHTunnelForwarder(target["ipAddress"], ssh_username="ubuntu", ssh_pkey="vockey.pem", remote_bind_address=("137.31.65.21", 3306))
    
    mysql = pymysql.connect(host="137.31.65.21", user="jeremy", password="jeremy123", db="sakila", port="3306", autocommit="true")
    cur = mysql.cursor()

    cur.execute(query)

    out = cur.fetchall()

    cur.close()
    mysql.close()
    tunnel.stop()

    return out
    

def getRandomSubordinate():
    return random.choice(subordinates)

def getBestSubordinate():
    bestSubordinate = ""
    bestPing = 1000000
    for subordinate in subordinates:
        pingResult = ping(subordinate["ipAddress"])
        if bestPing > pingResult.rtt_max_ms:
            bestSubordinate = subordinate
            bestPing = pingResult.rtt_max_ms
    return bestSubordinate

def processQuery(query, strategy):
    query = query.strip()

    if query.split(" ")[0].upper() == "SELECT":
        subordinate = ""
        if strategy == "randomized":
            subordinate = getRandomSubordinate()
        elif strategy == "customized":
            subordinate = getBestSubordinate()

        if subordinate != "":
            return executeQuery(query, subordinate)

    return executeQuery(query, "master")


if __name__ == "__main__":
    print("pick a strategy (enter the first letter):")
    print("(C) <customized strategy>")
    print("(R) <randomized strategy>")
    print("(D) <direct strategy>")
    choice = input(" - ")

    if choice in ["R"]:
        strategy = "randomized"
    elif choice in ["C"]:
        strategy = "customized"
    elif choice in ["D"]:
        strategy = "direct"
    else:
        print("invalid input, direct strategy set as default")
        strategy = "direct"

    while 1:
        print(processQuery(input("<" + strategy + " strategy> : "), strategy))