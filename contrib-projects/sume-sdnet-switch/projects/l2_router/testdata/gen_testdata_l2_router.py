#!/usr/bin/env python

#
# Copyright (c) 2017 Stephen Ibanez
# All rights reserved.
#
# This software was developed by Stanford University and the University of Cambridge Computer Laboratory
# under National Science Foundation under Grant No. CNS-0855268,
# the University of Cambridge Computer Laboratory under EPSRC INTERNET Project EP/H040536/1 and
# by the University of Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"),
# as part of the DARPA MRC research programme.
#
# @NETFPGA_LICENSE_HEADER_START@
#
# Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  NetFPGA licenses this
# file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@
#


from nf_sim_tools import *
import random
from collections import OrderedDict
import sss_sdnet_tuples

####################
# Global variables #
####################
NUM_PKTS = 64
NUM_VLANS = 2
vlan_id = 1
vlan_prio = 0
pkt_time = 0

########################
# pkt generation tools #
########################
pktsApplied = []
pktsExpected = []

# Pkt lists for SUME simulations
nf_applied = OrderedDict()
nf_applied[0] = []
nf_applied[1] = []
nf_applied[2] = []
nf_applied[3] = []
nf_expected = OrderedDict()
nf_expected[0] = []
nf_expected[1] = []
nf_expected[2] = []
nf_expected[3] = []

nf_port_map = {"nf0":0b00000001, "nf1":0b00000100, "nf2":0b00010000, "nf3":0b01000000, "dma0":0b00000010}
nf_id_map = {"nf0":0, "nf1":1, "nf2":2, "nf3":3}
inv_nf_id_map = {0:"nf0", 1:"nf1", 2:"nf2", 3:"nf3"}

sss_sdnet_tuples.clear_tuple_files()

def applyPkt(pkt, ingress, time):
    pktsApplied.append(pkt)
    sss_sdnet_tuples.sume_tuple_in['pkt_len'] = len(pkt)
    sss_sdnet_tuples.sume_tuple_in['src_port'] = nf_port_map[ingress]
    sss_sdnet_tuples.sume_tuple_expect['pkt_len'] = len(pkt)
    sss_sdnet_tuples.sume_tuple_expect['src_port'] = nf_port_map[ingress]
    pkt.time = time
    nf_applied[nf_id_map[ingress]].append(pkt)

def expPkt(pkt, egress, drop):
    pktsExpected.append(pkt)
    sss_sdnet_tuples.sume_tuple_expect['dst_port'] = nf_port_map[egress]
    sss_sdnet_tuples.sume_tuple_expect['drop'] = drop
    sss_sdnet_tuples.write_tuples()
    if egress in ["nf0","nf1","nf2","nf3"] and drop == False:
        nf_expected[nf_id_map[egress]].append(pkt)
    elif egress == 'bcast' and drop == False:
        nf_expected[0].append(pkt)
        nf_expected[1].append(pkt)
        nf_expected[2].append(pkt)
        nf_expected[3].append(pkt)

def write_pcap_files():
    wrpcap("src.pcap", pktsApplied)
    wrpcap("dst.pcap", pktsExpected)

    for i in nf_applied.keys():
        if (len(nf_applied[i]) > 0):
            wrpcap('nf{0}_applied.pcap'.format(i), nf_applied[i])

    for i in nf_expected.keys():
        if (len(nf_expected[i]) > 0):
            wrpcap('nf{0}_expected.pcap'.format(i), nf_expected[i])

    for i in nf_applied.keys():
        print "nf{0}_applied times: ".format(i), [p.time for p in nf_applied[i]]

##########################
# Topology for l2_switch #
##########################

MAC_addr = {}
MAC_addr[nf_id_map["nf0"]] = "00:00:00:00:01:00"
MAC_addr[nf_id_map["nf1"]] = "00:00:00:00:01:01"
MAC_addr[nf_id_map["nf2"]] = "00:00:00:00:01:02"
MAC_addr[nf_id_map["nf3"]] = "00:00:00:00:01:03"

IP_addr = {}
IP_addr[nf_id_map["nf0"]] = "10.0.1.0"
IP_addr[nf_id_map["nf1"]] = "10.0.1.1"
IP_addr[nf_id_map["nf2"]] = "10.0.1.2"
IP_addr[nf_id_map["nf3"]] = "10.0.1.3"

#######################
# Topology for router #
#######################
# Topology:
#                   Left                                       Right
#           H1 ------------------- |    SUME_SWITCH    | ------------------- H2
# (IP_addr_H1)                    Port1             Port2                   (IP_addr_H2)
# (MAC_addr_H1)             (MAC_addr_SPort1) (MAC_addr_SPort2)             (MAC_addr_H2)
#
#
# SUME(Port1) = 0b00000100       SUME(Port2) = 0b00010000
# SUME(MAC) = 00:00:01:00:00:02  SUME(MAC) = 00:00:01:00:00:03
#
# H1(MAC) = 00:00:01:00:00:01    H2(MAC) = 00:00:01:00:00:04
# H1(IP) = 192.168.0.1           H2(IP) = 10.0.0.1

MAC_addr_H1 = "00:00:01:00:00:01"
MAC_addr_SPort1 = "00:00:01:00:00:02"
MAC_addr_SPort2 = "00:00:01:00:00:03"
MAC_addr_H2 = "00:00:01:00:00:04"

IP_addr_H1 = "192.168.0.1"
IP_addr_H2 = "10.0.0.1"

# create pkgs
for i in range(NUM_PKTS):

    if (vlan_id == 1 or vlan_id == 3) :
        # switch src host (H1 or H2)
        src_ind = random.randint(1,2)

        if src_ind == 1:
            dst_ind = 2
        elif src_ind == 2:
            dst_ind = 1

        src_MAC = MAC_addr[src_ind]
        dst_MAC = MAC_addr[dst_ind]

        # create packets for l2_switch
        pkt = Ether(src=src_MAC, dst=dst_MAC) / Dot1Q(vlan=vlan_id, prio=vlan_prio) / IP(ttl=64, chksum=0x7ce7, src=IP_addr[src_ind], dst=IP_addr[dst_ind]) / TCP() / ('a'*5)
        pkt = pad_pkt(pkt, 64)
        ingress = inv_nf_id_map[src_ind]
        egress = inv_nf_id_map[dst_ind]
        applyPkt(pkt, ingress, pkt_time)
        drop = False
        expPkt(pkt, egress, drop)


    elif (vlan_id == 2 or vlan_id == 4) :
        # switch src host (H1 or H2)
        pkt_src_host = random.randint(1,2)
        pkt_dst_host = 0

        if pkt_src_host == 1:
            # H1 -> H2
            pkt_dst_host = 2
            src_IP = IP_addr_H1
            dst_IP = IP_addr_H2
            # APPLY = Left: H1 -> SPort1
            src_MAC_app = MAC_addr_H1
            dst_MAC_app = MAC_addr_SPort1
            # EXPECTED = Right: Sport2 -> H2
            src_MAC_exp = MAC_addr_SPort2
            dst_MAC_exp = MAC_addr_H2
        elif pkt_src_host == 2:
            # H2 -> H1
            pkt_dst_host = 1
            src_IP = IP_addr_H2
            dst_IP = IP_addr_H1
            # APPLY = Right: H2 -> Sport2
            src_MAC_app = MAC_addr_H2
            dst_MAC_app = MAC_addr_SPort2
            # EXP = Left: Sport1 -> H1
            src_MAC_exp = MAC_addr_SPort1
            dst_MAC_exp = MAC_addr_H1

        # create input pkts for router
        pkt_app = Ether(src=src_MAC_app, dst=dst_MAC_app) / Dot1Q(vlan=vlan_id, prio=vlan_prio) / IP(ttl=64, chksum=0x7ce7, src=src_IP, dst=dst_IP) / TCP() / ('a'*5)
        pkt_app = pad_pkt(pkt_app, 64)
        ingress = inv_nf_id_map[pkt_src_host]
        applyPkt(pkt_app, ingress, pkt_time)
        # create expected pkts
        drop = False
        # router P4 code decrement the ttl but dont tach in chksum, them we need force ttl and chksum fields
        pkt_exp = Ether(src=src_MAC_exp, dst=dst_MAC_exp) / Dot1Q(vlan=vlan_id, prio=vlan_prio) / IP(ttl=63, chksum=0x7ce7, src=src_IP, dst=dst_IP) / TCP() / ('a'*5)
        pkt_exp = pad_pkt(pkt_exp, 64)
        egress = inv_nf_id_map[pkt_dst_host]
        expPkt(pkt_exp, egress, drop)

    pkt_time += 1
    if vlan_id < NUM_VLANS :
        vlan_id += 1
        vlan_prio += 1
    else :
        vlan_id = 1
        vlan_prio = 1

write_pcap_files()
