defmodule Portal do
	use Application
	
	# See http://elixir-lang.org/docs/stable/elixir/Application.html
	# for more information on OTP Applications
	def start(_type, _args) do
		import Supervisor.Spec, warn: false
		
		children = [
			worker(Portal.Door, [])
		]

		# See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
		# for other strategies and supported options
		opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
		Supervisor.start_link(children, opts)
	end
	
	defstruct [:left, :right]

	@doc """
	Starts transfering `data` from `left` to `right`.
	"""
	def transfer(left, right, data) do
		# First add all data to the portal on the left
		for item <- data do
			Portal.Door.push(left, item)
		end

		# Returns a portal struct we will use next
		%Portal{left: left, right: right}
	end

	@doc """
	Pushes data to the right in the given `portal`.
	"""
  [:left, :right] |> Enum.map(fn direction ->
    def unquote(:"push_#{direction}")(portal) do
      push(portal, unquote(direction))
    end
  end)
  
	def push(portal, direction) do
    {entrance, exit} = get_entrance_exit(portal, direction)
    case Portal.Door.pop(entrance) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(exit, h)
    end
    
    portal
  end
	
  defp get_entrance_exit(portal, :left) do
    {portal.right, portal.left}
  end
  
  defp get_entrance_exit(portal, :right) do
    {portal.left, portal.right}
  end
  
	@doc """
	Shoots a new door with the given `color`.
	"""
	def shoot(color) do
		Supervisor.start_child(Portal.Supervisor, [color])
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
