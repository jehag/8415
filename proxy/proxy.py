# This script provides a way to execute SQL queries on a MySQL database running on an Amazon EC2 instance. 
# The script allows the user to choose between three different strategies for executing the query:
# - Randomized: The query is executed on a randomly chosen subordinate node
# - Customized: The query is executed on the subordinate node with the lowest ping time
# - Direct: The query is executed directly on the master node

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
    """
    This function executes the given `query` on the MySQL database running on the `target` node. 
    The `target` node can be either the master node or a subordinate node. 
    If the `target` node is a subordinate node, the function establishes an SSH tunnel to the master 
    node using the `sshtunnel` library before executing the query.

    The function returns the result of the query.
    """

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
    """
    This function returns a randomly chosen subordinate node from the `subordinates` list.
    """
    return random.choice(subordinates)

def getBestSubordinate():
    """
    This function returns the subordinate node with the lowest ping time from the `subordinates` list.
    """
    bestSubordinate = ""
    bestPing = 1000000
    for subordinate in subordinates:
        pingResult = ping(subordinate["ipAddress"])
        if bestPing > pingResult.rtt_max_ms:
            bestSubordinate = subordinate
            bestPing = pingResult.rtt_max_ms
    return bestSubordinate

def processQuery(query, strategy):
    """
    This function processes the given `query` according to the specified `strategy`. 
    If the `strategy` is "randomized" or "customized", the function calls the `getRandomSubordinate()` 
    or `getBestSubordinate()` function respectively to determine the target node for the query. 
    If the `strategy` is "direct", the function executes the query directly on the master node.

    The function returns the result of the query.
    """
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
    # Strategy choice.
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

    # Fake console.
    while 1:
        print(processQuery(input("<" + strategy + " strategy> : "), strategy))