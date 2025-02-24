##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source fir_compiler_lp_ddc.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project zubpm_hw zubpm_hw -part xczu6eg-ffvb1156-1-e
  set_property target_language VHDL [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:fir_compiler:7.2 }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP fir_compiler_lp_ddc
##################################################################

set fir_compiler_lp_ddc [create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_compiler_lp_ddc]

# User Parameters
set_property -dict [list \
  CONFIG.BestPrecision {true} \
  CONFIG.Clock_Frequency {117.3491} \
  CONFIG.CoefficientSource {COE_File} \
  CONFIG.Coefficient_File {/home/mead/rfbpm/fwk/zubpm/python/fir_filter.coe} \
  CONFIG.Coefficient_Fractional_Bits {21} \
  CONFIG.Coefficient_Sets {1} \
  CONFIG.Coefficient_Sign {Unsigned} \
  CONFIG.Coefficient_Structure {Symmetric} \
  CONFIG.Coefficient_Width {16} \
  CONFIG.ColumnConfig {51} \
  CONFIG.Data_Fractional_Bits {0} \
  CONFIG.Data_Width {24} \
  CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
  CONFIG.Output_Rounding_Mode {Full_Precision} \
  CONFIG.Output_Width {46} \
  CONFIG.Quantization {Quantize_Only} \
  CONFIG.S_DATA_Has_FIFO {false} \
  CONFIG.Sample_Frequency {117.3491} \
] [get_ips fir_compiler_lp_ddc]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $fir_compiler_lp_ddc

##################################################################
