extends Node


#byte code for subscription request
var hdr_res = PoolByteArray([0x82])
# length 2 bytes example [0x00,0x15] for small length of data
var lenn = 0
# message id set to your choice , response packet will contain it to verify
#work to be done : add check 
var msg_id = PoolByteArray([0x39,0x95])
# gen from user 1 byte alloted for small len
var topic_len = 0
# set to 0 , 1 ,or 2 read documentation , for easy sey qos to 0
var qos = PoolByteArray([0x02])
# keep alive time duration  ; 60s
var keep_alv =  PoolByteArray([0x00,0x3c])



func gen_sub_packet(topic):
	#get topic
	var topicc = topic.to_utf8()
	topic_len = len(topicc)
	lenn = topic_len + 5
	var packett = PoolByteArray([])
	packett.append_array(hdr_res)
	packett.append(lenn)
	packett.append_array(msg_id)
	#first of the byte of length
	packett.append(0x00)
	packett.append(topic_len)
	packett.append_array(topicc)
	packett.append_array(qos)
	return packett
	
