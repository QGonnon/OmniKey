extends Object
class_name Maths


static func clampi(value: float, min_value: float, max_value: float) -> float:
	return float(clamp(float(value), float(min_value), float(max_value)))
