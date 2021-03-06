#!/usr/bin/python

from __future__ import print_function
import sys
import os
import socket
import string
import re
import xml
import argparse
import calendar
import xml.etree.ElementTree as ET
from xml.dom import minidom
from datetime import datetime

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

def parse2JSON(xml):
    try:
        tree = ET.fromstring(xml)
    except:
        print_error("Cannot parse XML: %s!" % xml)
        return None
    print_info("root: %s" % tree.tag)
    for child in tree:
        print_info(child.tag)
    src = tree.find('{urn:ietf:params:xml:ns:bgp_monitor}SOURCE')
    # check if source exists, otherwise return
    if src is None:
        print_warn("Invalid XML: %s." % xml)
        return None

    src_addr = src.find('{urn:ietf:params:xml:ns:bgp_monitor}ADDRESS').text
    src_asn = src.find('{urn:ietf:params:xml:ns:bgp_monitor}ASN2').text

    # check wether it is a keep alive message
    keep_alive = tree.find('{urn:ietf:params:xml:ns:xfb}KEEP_ALIVE')
    if keep_alive is not None:
        print_log("BGP KEEP ALIVE %s (AS %s)" % (src_addr, src_asn))
        return None

    # check if its a bgp withdraw message
    withdraw = tree.find('.//{urn:ietf:params:xml:ns:xfb}WITHDRAW')
    if withdraw is not None:
        prefix = withdraw.text
        print_log ("BGP WITHDRAW %s by AS %s" % (prefix, src_asn))
        json = "{ \"nodes\": [ { \"asn\": \""+src_asn+"\", \"prefix\": [\""+prefix+"\"], \"type\": \"withdraw\", \"path\": [ \""+src_asn+"\" ] } ] }"
        return json

    # got here? proceed with bgp update parsing
    update = tree.find('{urn:ietf:params:xml:ns:xfb}UPDATE')
    if update is None:
        return None


    as_path = []
    asp = update.find('{urn:ietf:params:xml:ns:xfb}AS_PATH')
    if asp is not None:
        for asn in asp.findall('.//{urn:ietf:params:xml:ns:xfb}ASN2'):
                as_path.append(str(asn.text))

    #if len(as_path) == 0:
    #    as_path.append(src_asn)

    counter = 0
    json_as_path = ""
    last_asn = ""
    for asn in as_path:
        if last_asn != asn:
            if counter > 0:
                json_as_path += ", "
            json_as_path += "\""+asn+"\""
            last_asn = asn
        counter += 1

    #next_hop = update.find('{urn:ietf:params:xml:ns:xfb}NEXT_HOP').text
    prefixes = update.findall('.//{urn:ietf:params:xml:ns:xfb}NLRI')
    json = ""
    for prefix in prefixes:
        json += "{ \"nodes\": [ { \"asn\": \""+src_asn+"\", \"prefix\": [\""+prefix.text+"\"], \"type\": \"announcement\", \"path\": [ "+json_as_path+" ] } ] }\n"
    return json

def parse2XML(xml):
    try:
        tree = minidom.parseString(xml)
    except:
        print_error("Cannot parse XML: %s", xml)
        return None
    return tree.toprettyxml()

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
        sock.connect((addr,port))
    except:
        print_error("Failed to connect to BGPmon!")
        sys.exit(1)

    data = ""
    stream = ""
    while(True):
        data = sock.recv(1024)
        stream += data
        stream = string.replace(stream, "<xml>", "")
        while (re.search('</BGP_MONITOR_MESSAGE>', stream)):
            messages = stream.split('</BGP_MONITOR_MESSAGE>')
            msg = messages[0] + '</BGP_MONITOR_MESSAGE>'
            stream = '</BGP_MONITOR_MESSAGE>'.join(messages[1:])
            if json:
                output = parse2JSON(msg)
            else:
                output = parse2XML(msg)
            if output:
                print(output.strip(), file=sys.stdout)
                sys.stdout.flush()

    print_log(datetime.now().strftime('%Y-%m-%d %H:%M:%S') +  " done ...")
    # END

if __name__ == "__main__":
    main()
