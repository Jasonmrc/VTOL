function ModulesLoad()
    Events:Fire( "HelpAddItem",
        {
            name = "Vertical Take-Off and Landing",
            text = 
                "Ever wanted to do a vertical take-off or reverse in a plane? Now you can!\n"..
				"It is easy to take-off, but vertical landing can be tricky.\n\n"..
				"Use Z to do a Vertical Take-Off or Hover for Vertical Landing.\n"..
				"Use X to Reverse Thrust.\n"..
				"Use W and S to keep the nose and tail level when vertically landing.\n"..
				"Landing Gear automatically activate when using the Vertical Take-Off/Landing key and you are within 35m to a surface.\n"..
				"If enabled by the Admin, this Mod also allows EasyLand, which automatically slows planes when they are near the ground.\n"..
				"\nVertical Take-Off and Landing was developed by JasonMRC of Problem Solvers.\n"
        } )
end

function ModuleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Vertical Take-Off and Landing"
        } )
end


Events:Subscribe("ModulesLoad", ModulesLoad)
Events:Subscribe("ModuleUnload", ModuleUnload)