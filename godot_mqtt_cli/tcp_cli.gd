extends Node

# socket for communicating with mqtt broker
var s = StreamPeerTCP.new()

func _ready():
	#connect packet param : id
	var m = $connect_packet.gen_connect_pack("mqtt_4546ee48.757ba")
	#send connect packet
	s.put_data(m)
	# create packet for subscription     param : topic
	var subb = $subscribe_packet.gen_sub_packet("home")
	#send subscription packet
	s.put_data(subb)
	pass

func _init():
	#connect socket with server : params broker_ip ,port
	s.connect_to_host("127.0.0.1",1883)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#check if any new data arrived
	var j = s.get_available_bytes()
	#if persent
	if (j > 0):
		#parse the buffer and print output
		#for changing add return statements to below function
		parse_packets(s.get_data(j)[1])

		
#	pass



func parse_packets(arr):
	# len_2 of buffer
	var len_2 = len(arr)
	#f : base pointer 
	var f = 0
	#finished reading buffer
	while(f != len_2):
		#connection acknowledge response code 0x20
		if(arr[f] == 0x20):
			print("connection ack packet recieved")
			if(arr[3] == 0x00):
				print("connack : no error")
			elif(arr[3] == 0x01):
				print("connack :wrong protocol version")
			elif(arr[3] == 0x02):
				print("connack:identifier rejected")
			elif(arr[3] == 0x03):
				print("connack : broker unavailable")
			elif(arr[3] == 0x04):
				print("connack : incorrect u_name or password")
			elif(arr[3] == 0x05):
				print("connack : un authorised")
			else:
				print("connack : cant identify")
			#update base pointer
			f = f + 4
		#subscrpition acknowledge code 0x90
		elif(arr[f] == 0x90):
			print("subscription ack packet recieved")
			print("resp to message_id : id")
			if(arr[3] == 0x00):
				print("suback : accepted max_qos 0")
			elif (arr[3] == 0x01):
				print("suback : accepted max_qos 1")
			elif (arr[3] == 0x02):
				print("suback : accepted max_qos 2")
			elif(arr[3] == 0x80):
				print("suback : failure")
			else :
				print("unknown return code ")
			#update base pointer 
			f = f + 5
		#code for packet with data  qos 0 so will have to add code for 1 and 2
		elif(arr[f] == 0x30 ):
			print("recieved message")
			var mess_topic_len = arr[f+3]
			#get topic from buffer
			print("topic : " + arr.subarray(f+4 , f+ 4 + mess_topic_len -1).get_string_from_utf8 ())
			# get message
			print("message : " + arr.subarray(f+ 4 + mess_topic_len  ,f -1).get_string_from_utf8 ())
			#update base pointer
			f = arr[f+1] + 2
		else:
			f = len_2
			

# replace with your own trigger to publish  for example button press ....
func _input(event):
		if event is InputEventMouseButton:
			print("publishing packet ")
			#publish packet params : topic , data
			s.put_data($publish_packet.gen_publish_packet("home","enter data here!!!"))
