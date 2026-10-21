extends Node

const DUST_EFFECT = preload("res://00_global/visual_effects/dust_effect.tscn")
const HIT_PARTICLES = preload("res://00_global/visual_effects/hit_particles.tscn")

signal camera_shook(strength:float)

func _create_dust_effect(pos:Vector2) -> DustEffect:
	var dust:DustEffect = DUST_EFFECT.instantiate()
	add_child(dust)
	dust.global_position = pos
	return dust

func jump_dust(pos:Vector2) -> void:
	var dust:DustEffect = _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.JUMP)

func land_dust(pos:Vector2) -> void:
	var dust:DustEffect = _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.LAND)

func hit_dust(pos:Vector2) -> void:
	var dust:DustEffect = _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.HIT)

func hit_particles(pos:Vector2, dir:Vector2, settings:HitParticleSettings) -> void:
	var p:HitParticles = HIT_PARTICLES.instantiate()
	add_child(p)
	p.global_position = pos
	p.start(dir, settings)

func camera_shake(strength:float = 1.0) -> void:
	camera_shook.emit(strength)
