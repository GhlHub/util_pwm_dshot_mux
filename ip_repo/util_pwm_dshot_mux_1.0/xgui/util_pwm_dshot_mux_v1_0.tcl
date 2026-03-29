# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DIR_A_TO_B" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DIR_B_TO_A" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DSHOT_OEB_ACTIVE_LOW" -parent ${Page_0}


}

proc update_PARAM_VALUE.DIR_A_TO_B { PARAM_VALUE.DIR_A_TO_B } {
	# Procedure called to update DIR_A_TO_B when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIR_A_TO_B { PARAM_VALUE.DIR_A_TO_B } {
	# Procedure called to validate DIR_A_TO_B
	return true
}

proc update_PARAM_VALUE.DIR_B_TO_A { PARAM_VALUE.DIR_B_TO_A } {
	# Procedure called to update DIR_B_TO_A when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIR_B_TO_A { PARAM_VALUE.DIR_B_TO_A } {
	# Procedure called to validate DIR_B_TO_A
	return true
}

proc update_PARAM_VALUE.DSHOT_OEB_ACTIVE_LOW { PARAM_VALUE.DSHOT_OEB_ACTIVE_LOW } {
	# Procedure called to update DSHOT_OEB_ACTIVE_LOW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DSHOT_OEB_ACTIVE_LOW { PARAM_VALUE.DSHOT_OEB_ACTIVE_LOW } {
	# Procedure called to validate DSHOT_OEB_ACTIVE_LOW
	return true
}


proc update_MODELPARAM_VALUE.DSHOT_OEB_ACTIVE_LOW { MODELPARAM_VALUE.DSHOT_OEB_ACTIVE_LOW PARAM_VALUE.DSHOT_OEB_ACTIVE_LOW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DSHOT_OEB_ACTIVE_LOW}] ${MODELPARAM_VALUE.DSHOT_OEB_ACTIVE_LOW}
}

proc update_MODELPARAM_VALUE.DIR_A_TO_B { MODELPARAM_VALUE.DIR_A_TO_B PARAM_VALUE.DIR_A_TO_B } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIR_A_TO_B}] ${MODELPARAM_VALUE.DIR_A_TO_B}
}

proc update_MODELPARAM_VALUE.DIR_B_TO_A { MODELPARAM_VALUE.DIR_B_TO_A PARAM_VALUE.DIR_B_TO_A } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIR_B_TO_A}] ${MODELPARAM_VALUE.DIR_B_TO_A}
}

