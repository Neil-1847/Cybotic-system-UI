extends Control

func _ready():
	print("Cybotic System UI loaded successfully!")
	var title = Label.new()
	title.text = "義體改造系統"
	title.add_theme_font_size_override("font_size", 32)
	title.set_anchors_preset(Control.PRESET_CENTER)
	add_child(title)
	
	var info = Label.new()
	info.text = "系統正在初始化中...\n所有模組已加載！"
	info.add_theme_font_size_override("font_size", 16)
	info.position = Vector2(get_viewport_rect().size.x / 2 - 150, 200)
	add_child(info)
