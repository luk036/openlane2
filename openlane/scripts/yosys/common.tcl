# Copyright 2020-2023 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
proc read_deps {{power_defines "off"}} {
    if { [info exists ::env(SYNTH_DEFINES) ] } {
        foreach define $::env(SYNTH_DEFINES) {
            log "Defining $define"
            verilog_defines -D$define
        }
    }

    if { $power_defines == "on" } {
        if { [info exists ::env(SYNTH_POWER_DEFINE)] } {
            verilog_defines -D$::env(SYNTH_POWER_DEFINE)
        }
    }

    if { $::env(SYNTH_READ_BLACKBOX_LIB) } {
        log "Reading $::env(LIB) as a blackbox"
        foreach lib $::env(LIB) {
            read_liberty -lib -ignore_miss_dir -setattr blackbox $lib
        }
    }

    if { [info exists ::env(MACRO_LIBS) ] } {
        foreach lib $::env(MACRO_LIBS) {
            read_liberty -lib -ignore_miss_dir -setattr blackbox $lib
        }
    }

    if { [info exists ::env(EXTRA_LIBS) ] } {
        foreach lib $::env(EXTRA_LIBS) {
            read_liberty -lib -ignore_miss_dir -setattr blackbox $lib
        }
    }

    set verilog_include_args [list]
    if {[info exist ::env(VERILOG_INCLUDE_DIRS)]} {
        foreach dir $::env(VERILOG_INCLUDE_DIRS) {
            lappend verilog_include_args "-I$dir"
        }
    }

    if { [info exists ::env(MACRO_NLS)] } {
        read_verilog -sv -lib {*}$verilog_include_args $::env(MACRO_NLS)
    }

    if { [info exists ::env(EXTRA_VERILOG_MODELS)] } {
        read_verilog -sv -lib {*}$verilog_include_args {*}$::env(EXTRA_VERILOG_MODELS)
    }

}