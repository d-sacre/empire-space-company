class_name Gas

class O2:
	const min : float = 10.5
	const max : float = 21.0
	const minFactor : float = 0.5
	const maxFactor : float = 1.0
	
class CO2:
	const min : float = 0.04
	const max : float = 8.0
	const minFactor : float = 0.0
	const maxFactor : float = 1.0
	const ranges : Array[Vector2] = [Vector2(min, maxFactor), Vector2(0.08, 0.9), Vector2(1.5, 0.7), Vector2(5.0, 0.3), Vector2(max, minFactor)]
	
	static func Factors(co2 : float) -> Vector2:
		if co2 < min:
			return Vector2(ranges[0][1], ranges[1][1])
		for i in ranges.size():
			if co2 <= ranges[i][0]:
				return Vector2(ranges[i][1], ranges[i-1][1])
		return Vector2(ranges[-2][1], ranges[-1][1])

	static func Values(co2 : float) -> Vector2:
		if co2 < min:
			return Vector2(ranges[1][0], ranges[0][0])
		for i in ranges.size():
			if co2 <= ranges[i][0]:
				return Vector2(ranges[i][0], ranges[i-1][0])
		return Vector2(ranges[-2][0], ranges[-1][0])
