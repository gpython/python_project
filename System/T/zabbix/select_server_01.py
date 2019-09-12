import select
import socket
import Queue

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setblocking(False)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_address = ('localhost', 10000)
server.bind(server_address)
server.listen(10)

inputs = [server]
outputs = []
message_queue = {}
timeout = 20

while True:
    print "Waiting for active connection ..."
    readable, writable, exceptional = select.select(inputs, outputs, inputs, timeout)
    if not (readable or writable or exceptional):
        print "Select timeout not active connection Reconnection ...."
        continue
    for s in readable:
        if s is server:
            connection, client_address = s.accept()
            print "New Connection: ", client_address
            connection.setblocking(0)
            inputs.append(connection)
            message_queue[connection] = Queue.Queue()
        else:
            data = s.recv(1024)
            if data:
                print "Received data: ", data, " Client: ", s.getpeername()
                message_queue[s].put(data)
                if s not in outputs:
                    outputs.append(s)
            else:
                print "Close Connection: ", client_address
                if s in outputs:
                    outputs.remove(s)
                inputs.remove(s)
                s.close()
                del message_queue[s]
    for s in writable:
        try:
            msg = message_queue[s].get_nowait()
        except Queue.Empty:
            print "Connection: ", s.getpeername() , "Message Queue is Empty"
            outputs.remove(s)
        else:
            print "Sending Data: ", msg , " To ", s.getpeername()
            s.send(msg)
    for s in exceptional:
        print "Connection Exception: ", s.getpeername()
        inputs.remove(s)
        if s in outputs:
            outputs.remove(s)
        s.close()
        del message_queue[s]


