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
##################################################################################
# This software was modified by Institute of Informatics of the Federal
# University of Rio Grande do Sul (INF-UFRGS)
#
# Modified by:
#       Mateus Saquetti
#
# Description:
#       Modified to support the compile multiple virtual switches
#
# Create date:
#       12.12.2018
#
# Additional Comments:
#
#
##################################################################################

all:
	p4c-sdnet -o ${P4_SWITCH}.sdnet --toplevel_name ${P4_SWITCH} --sdnet_info .sdnet_switch_info_${P4_SWITCH}.dat ${P4_SWITCH}.p4
	${SUME_SDNET}/bin/p4_px_tables.py commands_${P4_SWITCH}.txt .sdnet_switch_info_${P4_SWITCH}.dat

clean:
	rm -f *.sdnet *.tbl .sdnet_switch_info.dat
