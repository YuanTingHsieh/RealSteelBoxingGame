#!/usr/bin/python

# Requirements:
# sudo apt-get install python-dev
# sudo pip install pybluez


import bluetooth
import threading

name = "BluetoothComm"
#uuid = "00001101-0000-1000-8000-00805F9B34FB"

server_sock = bluetooth.BluetoothSocket( bluetooth.RFCOMM )
server_sock.bind(("", 3))
server_sock.listen(3)
port = server_sock.getsockname()[1]

#bluetooth.advertise_service( server_sock, name )

print "Waiting for connection on RFCOMM channel %d" % port

class echoThread(threading.Thread):
    def __init__ (self,sock,client_info):
        threading.Thread.__init__(self)
        self.sock = sock
        self.client_info = client_info
    def run(self):
        try:
            while True:
                data = self.sock.recv(1024)
                if len(data) == 0: break
                print self.client_info, ": received [%s]" % data
                self.sock.send(data)
                print self.client_info, ": sent [%s]" % data
        except IOError:
            pass
        self.sock.close()
        print self.client_info, ": disconnected"

while True:
    client_sock, client_info = server_sock.accept()
    print client_info, ": connection accepted"
    echo = echoThread(client_sock, client_info)
    echo.setDaemon(True)
    echo.start()

server_sock.close()
print "all done"
