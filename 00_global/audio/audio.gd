extends Node

enum REVERB {NONE, SMALL, MEDIUM, LARGE}

@export var ui_focus_audio:AudioStream
@export var ui_select_audio:AudioStream
@export var ui_cancel_audio:AudioStream
@export var ui_sucess_audio:AudioStream
@export var ui_error_audio:AudioStream

var current_track:int = 0
var music_tweens:Array[Tween]
var ui_audio_player:AudioStreamPlaybackPolyphonic

@onready var music_1: AudioStreamPlayer = %Music1
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI

func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()

func play_ui_audio(audio:AudioStream) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio)

#region /// Ui Functions
func ui_focus_change() -> void:
	play_ui_audio(ui_focus_audio)

func ui_select() -> void:
	play_ui_audio(ui_select_audio)

func ui_cancel() -> void:
	play_ui_audio(ui_cancel_audio)

func ui_sucess() -> void:
	play_ui_audio(ui_sucess_audio)

func ui_error() -> void:
	play_ui_audio(ui_error_audio)
#endregion
