function ModulesLoad()
    Events:Fire( "HelpAddItem",
        {
            name = "Vertical Take-Off & Landing",
            text = 
                "Ever wanted to do a vertical take-off or landing or reverse in a plane? Now you can!\n"..
				"Use Z to do a Vertical Take-Off. Upward thrust builds up over a few moments.\n"..
				"Use Ctrl + Z to do a Vertical Landing. Use ScrollWheel to change the amount of downward thrust.\n"..
				"Use X to Reverse Thrust. Thrust builds up over a few moments.\n"..
				"Use W and S to keep the nose and tail level when vertically landing.\n"..
				"Landing Gear automatically activate when using the Vertical Take-Off/Landing key and you are within 35m of a surface.\n"..
				"'/vtol' To disable VTOL.\n"..
				"'/autoland' To disable AutoLand.\n"..
				"'/reversethrust' To disable Reverse Thrust.\n"..
				"\n:: Vertical Take-Off and Landing was developed by JasonMRC of Problem Solvers.\n"
        } )
end

function ModuleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Vertical Take-Off & Landing"
        } )
end

Events:Subscribe("ModulesLoad", ModulesLoad)
Events:Subscribe("ModuleUnload", ModuleUnload)