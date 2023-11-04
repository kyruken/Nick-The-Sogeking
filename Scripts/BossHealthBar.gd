extends ProgressBar

var boss_health
var boss

func _ready():
	boss = get_tree().get_first_node_in_group("boss")
	boss_health = boss.health
	self.value = boss_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_attribute()

func update_attribute():
	boss_health = boss.health
	self.value = boss_health

func transfer_phase_2():
	pass
