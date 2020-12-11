extends Node

var hdr_res = PoolByteArray([0x30])
var lenn = 0
var topic_len =0


func _ready():
	pass # Replace with function body.



func gen_publish_packet(topic,data):
	var packett = PoolByteArray([])
	#add control code 
	packett.append_array(hdr_res)
	#find length of the entire packet
	lenn =  2 +  len(topic) + len(data)
	#add length byte to packet for samll packets
	packett.append(lenn)
	#added for padding ,small topic only
	packett.append(0x00)
	#add length of topic 
	packett.append(len(topic))
	#add topic to data
	packett.append_array(topic.to_utf8())
	#add data to data
	packett.append_array(data.to_utf8())
	return(packett)
