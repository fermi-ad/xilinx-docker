#!/usr/bin/expect
# This is a generic template that can be filled out to
# automate any installation that requires automated user input.
#
# Number of arguments = [llength $argv]
set argcount [llength $argv];

set timeout -1;
# Arguments: 
# (1) - Installer package name
set installer_exec [lindex $argv 0];
# (2) - Installer arguments
#     - ARG1 = petalinux installation directory
set argument_one [lindex $argv 1];

# Launch the installer
# as of 2020.1, the installer requires the "-d" switch to specify an install folder
spawn $installer_exec -d $argument_one

#############################################################
# Start monitoring the installer progress
#############################################################
# INFO: Checking installation environment requirements...
set timeout 10
expect {
	"*INFO: Checking installation environment requirements...*" { }
	timeout {
		puts "Exiting due to timeout (installation environment requirements)"
		exit 1
	}
}

# INFO: Checking installer checksum...
set timeout 100
expect { 
	"*INFO: Checking installer checksum...*" { }
	timeout {
		puts "Exiting due to timeout (installer checksum)"
		exit 1
	}
}

# INFO: Extracting PetaLinux installer...
set timeout 300
expect { 
	"*INFO: Extracting PetaLinux installer...*" { }
	timeout {
		puts "Exiting due to timeout (installer extraction)"
		exit 1
	}
}

# Press Enter to display the license agreements
set timeout 600 
expect { 
	"*Press Enter to display the license agreements*" { }
	timeout {
		puts "Exiting due to timeout (display license agreements)"
		exit 1
	}
}
send "\r"

# END USER LICENSE AGREEMENT FOR PETALINUX TOOLS
set timeout 10
expect { 
	"*END USER LICENSE AGREEMENT FOR PETALINUX TOOLS*" { }
	timeout {
		puts "Exiting due to timeout (petalinux eula)"
		exit 1
	}
}
send "q"

# Do you accept Xilinx End User License Agreement? [y/N] >
# 'Do you accept Xilinx End User License Agreement? \[y\/N\] \>' { }

set timeout 60
expect {
	"*Do you accept Xilinx End User License Agreement?*" { }
	timeout {
		puts "Exiting due to timeout (accept petalinux eula)"
		exit 1
	}
}
send "y\r"

# CAREFULLY READ THIS COLLECTION OF INFORMATION AND LICENSE AGREEMENTS.
set timeout 10
expect {
	"*CAREFULLY READ THIS COLLECTION OF INFORMATION AND LICENSE AGREEMENTS.*" { }
	timeout {
		puts "Exiting due to timeout (third party eula)"
		exit 1
	}
}
send "q"

# Do you accept Third Party End User License Agreement? [y/N] > 
set timeout 10
expect {
	"*Do you accept Third Party End User License Agreement?*" { }
	timeout {
		puts "Exiting due to timeout (accept third party eula)"
		exit 1
	}
}
send "y\r"

# INFO: Installing PetaLinux...
set timeout 300
expect {
	"*INFO: Installing PetaLinux...*" { }
	timeout {
		puts "Exiting due to timeout (petalinux install)"
		exit 1
	}
}

# WARNING: PetaLinux installation directory ... is not empty!
set timeout 10
expect {
	"*WARNING: Petalinux installation directory*" {
		send "y\r"
	}
}

# INFO: PetaLinux SDK has been installed
set timeout 1200
expect {
	"*INFO: PetaLinux SDK has been installed*" { }
	timeout {
		puts "Exiting due to timeout (sdk install)"
		exit 1
	}
}

expect eof