# Portal

**TODO: Add description**
- Build Documention 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

 1. Add portal to your list of dependencies in `mix.exs`:

        def deps do
          [{:portal, "~> 0.0.1"}]
        end

 2. Ensure portal is started before your application:

        def application do
          [applications: [:portal]]
        end
		
				
## Usage 

 1. Type the command iex -S mix to load the application
	
 2. Shoot doors using the start_link function:

        Portal.Door.start_link(:blue)  
        Portal.Door.start_link(:orange)
		
 3. Transfer data using the transfer function:
	
        portal = Portal.transfer(:blue, :orange, [1, 2, 3])
	
 4. Push the data left or right using the push_left or push_right function:

        Portal.push_left(portal)  
        Portal.push_right(portal)
