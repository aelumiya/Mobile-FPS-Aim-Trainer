extends StaticBody3D

func hit():
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 1.15, 0.05)
	tween.tween_property(self, "scale", scale * 0.01, 0.05) # avoid zero-scale warning
	tween.finished.connect(queue_free)
