# Copyright 2020-2022 Efabless Corporation
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

gds read $::env(CURRENT_GDSII)
load $::env(DESIGN_NAME) -dereference

set extdir $::env(STEP_DIR)/extraction
set feedback_file $::env(STEP_DIR)/feedback.txt
set netlist $::env(STEP_DIR)/$::env(DESIGN_NAME).spice

file mkdir $extdir
cd $extdir

extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
if { ! $::env(LVS_CONNECT_BY_LABEL) } {
    extract unique
}
# extract warn all
extract

ext2spice lvs
ext2spice -o $netlist $::env(DESIGN_NAME).ext
feedback save $feedback_file
# exec cp $::env(DESIGN_NAME).spice $::env(signoff_results)/$::env(DESIGN_NAME).spice