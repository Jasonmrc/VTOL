function ModulesLoad()
    Events:Fire( "HelpAddItem",
        {
            name = "Vertical Take Off and Landing",
            text = 
                "Ever wanted to do a vertical take-off or reverse in a plane? Now you can!\n"..
				"It is easy to take-off, but vertical landing can be tricky.\n\n"..
				"Use Z to do a Vertical Take-Off or Hover for Vertical Landing.\n"..
				"Use X to Reverse Thrust.\n"..
				"Use CTRL when Landing to activate the Landing gear.\n"
        } )
end

function ModuleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Vertical Take Off and Landing"
        } )
end


Events:Subscribe("ModulesLoad", ModulesLoad)
Events:Subscribe("ModuleUnload", ModuleUnload)