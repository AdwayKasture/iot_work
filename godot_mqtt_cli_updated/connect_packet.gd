extends Node


#control code for creating connect packet
var hdr_res = PoolByteArray([0x10])
# length of packet
var lenn = 0
#length of protocol fixed ; spoiler alert its MQTT
var proto_len = PoolByteArray([0x00,0x04])
#proto again shockingly its mqtt well utf8 bytes 
var proto = PoolByteArray([0x4d,0x51,0x54,0x54])
#version is 3.1 i think 
var ver = PoolByteArray([0x04])
#set for specifications (to be implemented) 
#12345678
#1 -> uname flag
#2 -> passwd flag
#3 -> will retain
#45 -> qos
#6 -> will flag
#7 -> clean session set to 1
#8 ->reserved
var connect_flags = PoolByteArray([0x02])
# duration set to 60s 
var keep_alv =  PoolByteArray([0x00,0x3c])




func gen_connect_pack(cli_id_inp):
	#client id
	var cli_id = cli_id_inp.to_utf8()
	#size of cli_id
	var cli_id_len = len(cli_id)
	#final length
	lenn = cli_id_len + 2 + 4+2+2+2
	#make the packet by adding all parts
	var packett = PoolByteArray([])
	packett.append_array(hdr_res)
	packett.append(lenn)
	packett.append_array(proto_len)
	packett.append_array(proto)
	packett.append_array(ver)
	packett.append_array(connect_flags)
	packett.append_array(keep_alv)
	#padding for client id keep length within range
	packett.append(0x00)
	packett.append(cli_id_len)
	packett.append_array(cli_id)
	return packett
	
