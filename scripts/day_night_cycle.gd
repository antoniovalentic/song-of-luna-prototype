extends Node3D

@onready var sun: DirectionalLight3D = $Sun
@onready var moon: DirectionalLight3D = $Moon
@onready var environment: WorldEnvironment = $WorldEnvironment

@export_category("Day settings")
@export_range(0, 200, 1) var DAY_LENGTH: float = 20.0
@export_range(0, 1, 0.1) var START_TIME: float = 0.3

@export_category("Sun settings")
@export var SUN_COLOR: Gradient
@export var SUN_INTENSITY: Curve

@export_category("Moon settings")
@export var MOON_COLOR: Gradient
@export var MOON_INTENSITY: Curve

@export_category("Environment settings")
@export var SKY_TOP_COLOR: Gradient
@export var SKY_HORIZON_COLOR: Gradient

## Current time in the cycle [0-1]
var time: float = 0.5

## Rate of change in the cycle
var time_rate: float

# Called when the node enters the scene tree for the first time.
func _ready():
	time_rate = 1.0 / DAY_LENGTH
	time = START_TIME


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Multiply with delta so that time updates every second, and not every frame (decouple time from frame rate)
	time += time_rate * delta

	if time >= 1.0:
		time = 0.0
	
	# Sun rotation (+ 90 degree offset)
	sun.rotation_degrees.x = time * 360 + 90
	# Sun light
	sun.light_color = SUN_COLOR.sample(time)
	sun.light_energy = SUN_INTENSITY.sample(time)

	# Moon rotation
	moon.rotation_degrees.x = time * 360 + 270
	# Moon light
	moon.light_color = MOON_COLOR.sample(time)
	moon.light_energy = MOON_INTENSITY.sample(time)

	# Enable/Disable sun and moon
	sun.visible = sun.light_energy > 0
	moon.visible = moon.light_energy > 0

	# Sky color
	environment.environment.sky.sky_material.set("sky_top_color", SKY_TOP_COLOR.sample(time))
	environment.environment.sky.sky_material.set("sky_horizon_color", SKY_HORIZON_COLOR.sample(time))
	environment.environment.sky.sky_material.set("ground_bottom_color", SKY_TOP_COLOR.sample(time))
	environment.environment.sky.sky_material.set("ground_horizon_color", SKY_HORIZON_COLOR.sample(time))
