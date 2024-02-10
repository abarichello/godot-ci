extends Node2D

signal start_zoom_out

const ZOOM_DELTA: float = 0.2
const MOVE_DELTA: float = 0.353

@onready var camera: Camera2D = $Path2D/PathFollow2D/MenuCamera
var camera_zooming: bool = false

func _process(delta: float):
	if camera_zooming:
		self.zoom_out_proccess(delta)

func zoom_out_proccess(delta: float) -> void:
	var delta_speed = delta * ZOOM_DELTA
	if camera.zoom < Vector2(1, 1):
		camera.zoom += Vector2(delta_speed, delta_speed)
	else:
		self.camera_zooming = false

	$Path2D/PathFollow2D.progress_ratio += delta * MOVE_DELTA

func _on_Main_start_zoom_out():
	self.camera_zooming = true
