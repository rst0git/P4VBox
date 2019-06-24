# Copyright (c) 2016 Robert Halstead
# All rights reserved.
#
# This software was developed by Xilinx Labs.
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
# Vivado Launch Script
#### Change design settings here #######
set design nf_sume_sdnet4
set top nf_sume_sdnet4
set device xc7vx690t-3-ffg1761
set proj_dir ./ip_proj
set ip_version 1.00
set lib_name NetFPGA

#####################################
# Project Settings
#####################################
create_project -name ${design} -force -dir "./${proj_dir}" -part ${device}
set_property source_mgmt_mode All [current_project]  
set_property top ${top} [current_fileset]
set_property ip_repo_paths $::env(SUME_FOLDER)/lib/hw/  [current_fileset]
update_ip_catalog
puts "nf_sume_sdnet4"

#####################################
# Project Structure & IP Build
#####################################
#read_verilog "./wrapper4/sdnet_to_sume.v"
read_verilog "./wrapper4/sume_to_sdnet.v"
read_verilog "./wrapper4/nf_sume_sdnet4.v"
read_verilog "./wrapper4/changeEndian.v"

## to compile SDNet 2016.3
#add_files -scan_for_includes ./SimpleSumeSwitch/axi_lite_ipif_v3_0b/

add_files -scan_for_includes ./SimpleSumeSwitch/
import_files -force

## to compile SDNet 2016.3
#set_property library axi_lite_ipif_v3_0b [get_files $proj_dir/nf_sume_sdnet4.srcs/sources_1/imports/nf_sume_sdnet4_ip/SimpleSumeSwitch/axi_lite_ipif_v3_0b/hdl/src/vhdl/address_decoder.vhd]
#set_property library axi_lite_ipif_v3_0b [get_files $proj_dir/nf_sume_sdnet4.srcs/sources_1/imports/nf_sume_sdnet4_ip/SimpleSumeSwitch/axi_lite_ipif_v3_0b/hdl/src/vhdl/axi_lite_ipif.vhd]
#set_property library axi_lite_ipif_v3_0b [get_files $proj_dir/nf_sume_sdnet4.srcs/sources_1/imports/nf_sume_sdnet4_ip/SimpleSumeSwitch/axi_lite_ipif_v3_0b/hdl/src/vhdl/ipif_pkg.vhd]
#set_property library axi_lite_ipif_v3_0b [get_files $proj_dir/nf_sume_sdnet4.srcs/sources_1/imports/nf_sume_sdnet4_ip/SimpleSumeSwitch/axi_lite_ipif_v3_0b/hdl/src/vhdl/pselect_f.vhd]
#set_property library axi_lite_ipif_v3_0b [get_files $proj_dir/nf_sume_sdnet4.srcs/sources_1/imports/nf_sume_sdnet4_ip/SimpleSumeSwitch/axi_lite_ipif_v3_0b/hdl/src/vhdl/slave_attachment.vhd]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
ipx::package_project

set_property name ${design} [ipx::current_core]
set_property library ${lib_name} [ipx::current_core]
set_property vendor_display_name {NetFPGA} [ipx::current_core]
set_property company_url {www.netfpga.org} [ipx::current_core]
set_property vendor {NetFPGA} [ipx::current_core]
set_property supported_families {{virtex7} {Production}} [ipx::current_core]
set_property taxonomy {{/NetFPGA/Generic}} [ipx::current_core]
set_property version ${ip_version} [ipx::current_core]
set_property display_name ${design} [ipx::current_core]
set_property description ${design} [ipx::current_core]

ipx::add_user_parameter {C_M_AXIS_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]
set_property display_name {C_M_AXIS_DATA_WIDTH} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]
set_property value {256} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]

ipx::add_user_parameter {C_S_AXIS_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_S_AXIS_DATA_WIDTH [ipx::current_core]]
set_property display_name {C_S_AXIS_DATA_WIDTH} [ipx::get_user_parameter C_S_AXIS_DATA_WIDTH [ipx::current_core]]
set_property value {256} [ipx::get_user_parameter C_S_AXIS_DATA_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_S_AXIS_DATA_WIDTH [ipx::current_core]]
  
ipx::add_user_parameter {C_M_AXIS_TUSER_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property display_name {C_M_AXIS_TUSER_WIDTH} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property value {128} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]

ipx::add_user_parameter {C_S_AXIS_TUSER_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_S_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property display_name {C_S_AXIS_TUSER_WIDTH} [ipx::get_user_parameter C_S_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property value {128} [ipx::get_user_parameter C_S_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_S_AXIS_TUSER_WIDTH [ipx::current_core]]

ipx::add_user_parameter {C_S_AXI_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]
set_property display_name {C_S_AXI_DATA_WIDTH} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]
set_property value {32} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]

ipx::add_user_parameter {C_S_AXI_ADDR_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]
set_property display_name {C_S_AXI_ADDR_WIDTH} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]
set_property value {12} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]

ipx::add_user_parameter {SDNET_ADDR_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter SDNET_ADDR_WIDTH [ipx::current_core]]
set_property display_name {SDNET_ADDR_WIDTH} [ipx::get_user_parameter SDNET_ADDR_WIDTH [ipx::current_core]]
set_property value {11} [ipx::get_user_parameter SDNET_ADDR_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter SDNET_ADDR_WIDTH [ipx::current_core]]

ipx::add_subcore xilinx.com:ip:axis_data_fifo:1.1 [ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
ipx::add_subcore xilinx.com:ip:axis_data_fifo:1.1 [ipx::get_file_groups xilinx_anylanguagebehavioralsimulation -of_objects [ipx::current_core]]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]

update_ip_catalog -rebuild 
ipx::infer_user_parameters [ipx::current_core]

ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
update_ip_catalog
close_project

