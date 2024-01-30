"Resource/UI/SinglePlayer.res"
{
	"SinglePlayer"
	{
		"ControlName"			"Frame"
		"fieldName"				"SinglePlayer"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"5"
		"tall"					"3"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"dialogstyle"			"1"
	}
	
	"BtnNewGame"
	{
		"ControlName"			"BaseModHybridButton"
		"fieldName"				"BtnNewGame"
		"command"				"Extras"
		"xpos"					"0"
		"ypos"					"25"
		"wide"					"0"
		"tall"					"20"
		"visible"				"1"	
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnContinueGame"
		"navDown"				"BtnLoadGame"
		"labelText"				"#PORTAL2_NewGame"
		"style"					"DefaultButton"
	}

	"BtnContinueGame"
	{
		"ControlName"			"BaseModHybridButton"
		"fieldName"				"BtnContinueGame"
		"command"				"BtnContinueGame"
		"xpos"					"0"
		"ypos"					"50"
		"wide"					"0"
		"tall"					"20"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnDeveloperCommentary"
		"navDown"				"BtnNewGame"
		"labelText"				"#PORTAL2_ContinueGame"
		"style"					"DefaultButton"
	}

}