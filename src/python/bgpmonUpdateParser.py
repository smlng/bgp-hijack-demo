#!/usr/bin/python

from __future__ import print_function
import sys
import socket
import subprocess
import os
import re
import argparse
import radix
import calendar
from datetime import datetime
from time import sleep
from netaddr import IPSet, IPAddress
from collections import deque, OrderedDict

verbose = False
warning = False
logging = False

def print_log(*objs):
    if logging or verbose:
        print("[LOGS] ", *objs, file=sys.stderr)

def print_info(*objs):
    if verbose:
        print("[INFO] ", *objs, file=sys.stderr)

def print_warn(*objs):
    if warning or verbose:
        print("[WARN] ", *objs, file=sys.stderr)

def print_error(*objs):
    print("[ERROR] ", *objs, file=sys.stderr)

def outputJSON(msg):
    pass

def outputXML(msg):
    print(msg)

def main():
    parser = argparse.ArgumentParser(description='', epilog='')
    parser.add_argument('-l', '--logging',  help='Ouptut log info.', action='store_true')
    parser.add_argument('-w', '--warning',  help='Output warnings.', action='store_true')
    parser.add_argument('-v', '--verbose',  help='Verbose output, with debug and logging infos and warnings.', action='store_true')
    parser.add_argument('-p', '--port',     help='Port of BGPmon Update XML stream, default: 50001', type=int, default=50001)
    parser.add_argument('-a', '--addr',     help='Address or name of BGPmon host, default: localhost', default='localhost')
    parser.add_argument('-j', '--json',     help='Set output format to JSON, default: XML.', action='store_true')
    args = vars(parser.parse_args())
    
    global verbose
    verbose   = args['verbose']
    global warning
    warning   = args['warning']
    global logging
    logging = args['logging']
    
    # BEGIN
    print_log(datetime.now().strftime('%Y-%m-%d %H:%M:%S') + " starting ...")

    port = args['port']
    addr = args['addr'].strip()
    json = args['json']

    print_log(datetime.now().strftime('%Y-%m-%d %H:%M:%S') + " connecting to BGPmon Update XML stream (%s:%d)" % (addr,port))

    sock =  socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect(addr,port)
    except:
        print_error("Failed to connect to BGPmon!")
        sys.exit(1)

    data = ""
    stream = ""
    while(True):
        try:
            data = sock.recv(1024)
        except:
            print_error("Failed to receive data!")
        else:
            stream += data
        if (re.search('</BGP_MONITOR_MESSAGE>', stream)):
            messages = stream.split('</BGP_MONITOR_MESSAGE>')
            msg = messages[0] + '</BGP_MONITOR_MESSAGE>'
            stream = '</BGP_MONITOR_MESSAGE>'.join(messages[1:])
            if json:
                outputJSON(msg)
            else:
                outputXML(msg)

    print_log(datetime.now().strftime('%Y-%m-%d %H:%M:%S') +  " done ...")
    # END

if __name__ == "__main__":
    main()