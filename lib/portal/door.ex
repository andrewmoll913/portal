defmodule Portal.Door do
	@doc """
	Starts a door with the given `color`
	
	The color is given as a name so we can identify
	the door by color name instead of using a PID
	"""
	def start_link(color) do
		Agent.start_link(fn -> [] end, name: color)
	end
	
	@doc"""
	Get the data currently in the `door`
	"""
	def get(door) do
		Agent.get(door, fn list -> list end)
	end
	
	@doc """
	Pushes `value` into the door.
	"""
	def push(door, value) do
		Agent.update(door, fn list -> [value|list] end)
	end
	
	@doc """
	Pops a value from the `door`
	Returns `{:ok, value}` if there is a value
	or `:error` if the hole is currently empty.
	"""	
	def pop(door) do
		Agent.get_and_update(door, fn
			[]	-> {:error, []}
			[h|t]	-> {{:ok, h}, t}
		end)
	end
end

defimpl Inspect, for: Portal do
	def inspect(%Portal{left: left, right: right}, _) do
		left_door	= inspect(left)
		right_door	= inspect(right)
		
		left_data	= inspect(Enum.reverse(Portal.Door.get(left)))
		right_data	= inspect(Portal.Door.get(right))
		
		max = max(String.length(left_door), String.length(left_data))
		
		"""
		#Portal<
			#{String.rjust(left_door, max)} <=> #{right_door}
			#{String.rjust(left_data, max)} <=> #{right_data}
		>
		"""
	end
end