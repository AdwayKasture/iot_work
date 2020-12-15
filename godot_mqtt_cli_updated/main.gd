extends Node2D


const mqtt_node = preload("res://mqtt.tscn")

var start = false
# Declare member variables here. Examples:
var mqtt
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_connect_button_pressed():
	if(! start):
		mqtt  = mqtt_node.instance()
		self.add_child(mqtt)
		$mqtt.connect("all_pack_ready" , self,"_on_ready")
		start = true
	pass # Replace with function body.


func _on_subscribe_button_down():
	$mqtt.send_packet($mqtt.gen_sub_packet($topic_sub.text))

	pass # Replace with function body.

func _on_ready():
	print($mqtt.message_topic,$mqtt.message_data)


func _on_publish_button_down():
	$mqtt.send_packet($mqtt.gen_pub_packet($topic_pub.text,$content_pub.text))
	pass # Replace with function body.
