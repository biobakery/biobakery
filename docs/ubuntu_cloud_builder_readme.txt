
Biobakery VM Ubuntu cloud builder notes


The process as outlined below seems to work pretty well and is quite fast, it should take less than 10 minutes to set up for the first time, even less if the lab creates pre-made config files with all the appropriate options set. The final result is a VM accessible through ssh running Ubuntu with any desired software packages which can be accessed via apt-get pre-installed. If the goal is the run biobakery from the cloud and allow users to ssh in to a personal VM, then this software package seems perfectly reasonable and appealing for use in this function. Note however that to the best of my ability to tell this process does NOT create an iso which could be manually run on VirtualBox or VMWareFusion; this process only produces a cloud vm into which a user may shh. 



DEPENDANCY NOTE: This process requires Ubuntu version 12.10 or higher to work!


Steps:
(1) Download the Ubuntu Cloud Image.
	For example with:
	wget -O my_new_vm.img.dist http://cloud-images.ubuntu.com/server/releases\
	/12.04/release/ubuntu-12.04-server-cloudimg-amd64-disk1.img

	(Takes about 3 minutes)

(2) Install packages:
	- qemu
		-- sudo apt-get install qemu-utils
	- virsh
		-- sudo apt-get install libvirt-bin
	- cloud-utils
		-- sudo apt-get install cloud-utils
	- kvm
		-- sudo apt-get install kvm
	- genisoimage
		-- sudo apt-get install genisoimage

	(Takes about 1-3 minutes total)

(3) Reformat vanilla disk image to qemu format
	- qemu-img convert -O qcow2 <downloaded vanilla disk image> <new name for vanilla disk image>
		-- example: qemu-img convert -O qcow2 my_new_vm.img.dist my_new_vm.img

(4) Make a config file. Include important user information like the default user and password for the computer, and an ssh key to allow the VM to communicate with the system as a whole.
	Use the following steps:
	$ cat > my-user-data <<EOF
	#cloud-config
	password: password
	chpasswd: { expire: False }
	ssh_pwauth: True
	ssh_authorized_keys:
	 - ssh-rsa {insert your own ssh public key here}
	packages:
		- curl
		- 
	EOF

(5) Add packages and options to the config file. There are lots of options about upgrading, defaults on shutdown, automatically installed packages, etc. I'm not sure what all is desired here for the biobakery, but lots of options are well-documented in reference (2).

(6) Make an image seed from the config file made in step (4).
	- Example:
		-- cloud-localds my-seed.img my-user-data

	DEPENDANCY NOTE: This step requires Ubuntu version 12.10 or higher to work. The cloud-utils package need to interact with some built-in feature of Ubuntu > 12.10 to function.

(7) Make an xml 'domain definition' file. The example below can be used, changing every reference to a file in 'home/ubuntu' to the appropriate location of the files created in steps (3) and (6). Also change the <type-arch> tag option if the machine to be run on is not 64-bit.
	- Example:
	$ cat > my_new_vm.xml <<EOF
	<domain type='kvm'>
	  <name>my_new_vm</name>
	  <memory unit='MiB'>1024</memory>
	  <currentMemory unit='MiB'>1024</currentMemory>
	  <vcpu placement='static'>1</vcpu>
	  <os>
	    <type arch='x86_64' machine='pc-1.2'>hvm</type>
	    <boot dev='hd'/>
	    <bootmenu enable='no'/>
	  </os>
	  <features>
	    <acpi/>
	    <apic/>
	    <pae/>
	  </features>
	  <clock offset='utc'/>
	  <on_poweroff>destroy</on_poweroff>
	  <on_reboot>restart</on_reboot>
	  <on_crash>restart</on_crash>
	  <devices>
	    <emulator>/usr/bin/kvm</emulator>
	    <disk type='file' device='disk'>
	      <driver name='qemu' type='qcow2'/>
	      <source file='/home/ubuntu/my_new_vm.img'/>
	      <target dev='vda' bus='virtio'/>
	      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
	    </disk>
	    <disk type='file' device='disk'>
	      <driver name='qemu' type='raw'/>
	      <source file='/home/ubuntu/my-seed.img'/>
	      <target dev='hda' bus='ide'/>
	      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
	    </disk>
	    <interface type='network'>
	      <source network='default'/>
	      <model type='virtio'/>
	      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
	    </interface>
	    <serial type='pty'>
	      <target port='0'/>
	    </serial>
	    <console type='pty'>
	      <target type='serial' port='0'/>
	    </console>
	    <graphics type='vnc' port='-1' autoport='yes'/>
	  </devices>
	</domain>
	EOF

(8) Build and start/launch the VM.
	- virsh define my_new_vm.xml
	- virsh start my_new_vm
	- virsh console my_new_vm

(9) The escape key for exiting the current session and gaining back control of the console is "ctrl-]".


Useful notes:

(1) If you ever need to get rid of a vm that you have previously created, use:
	- virsh destroy my_new_vm
 
Useful References:
(1) https://help.ubuntu.com/13.04/serverguide/cloud-images-and-vmbuilder.html

(2) http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/head:/doc/examples/cloud-config.txt

(3) http://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Tips_and_tricks-Using_qemu_img.html

(4) General Documentation for QEMU: http://en.wikibooks.org/wiki/QEMU/Images