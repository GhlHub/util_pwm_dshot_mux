set repo_root [file normalize [file dirname [info script]]]
set rtl_dir   [file join $repo_root rtl]
set build_dir [file join $repo_root .build_ip]
set ip_root   [file join $repo_root ip_repo util_pwm_dshot_mux_1.0]

file mkdir $build_dir
file mkdir [file dirname $ip_root]

create_project -force util_pwm_dshot_mux_pkg $build_dir -part xcsu10p-cmva361-1-e
set_property target_language Verilog [current_project]

add_files -norecurse [file join $rtl_dir util_pwm_dshot_mux.sv]
set_property top util_pwm_dshot_mux [current_fileset]
update_compile_order -fileset sources_1

ipx::package_project \
    -root_dir $ip_root \
    -vendor ghl.local \
    -library user \
    -taxonomy /UserIP \
    -import_files \
    -set_current true

set core [ipx::current_core]

set_property name util_pwm_dshot_mux $core
set_property display_name {Utility PWM / DShot Mux} $core
set_property description {PWM input and bidirectional DShot mux around IOBUFT/OBUF with external SN74LVC1T45 direction timing.} $core
set_property vendor_display_name {GHL} $core
set_property supported_families {spartanuplus Production} $core

ipx::merge_project_changes files $core
ipx::infer_user_parameters $core
ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::check_integrity -quiet $core
ipx::save_core $core

close_project
puts "Packaged IP at $ip_root"
