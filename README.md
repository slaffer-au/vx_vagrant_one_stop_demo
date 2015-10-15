# Cumulus VX - CLAG Demonstration
### _A two-tier, eight switch topology of Cumulus VX switches in a MLAG setup deployed with Vagrant and provisioned with Ansible._


#### Prerequisites
  * Download the Cumulus VX file for Vagrant Box.
   * https://cumulusnetworks.com/cumulus-vx/download/
  * VirtualBox must be installed.
    * https://www.virtualbox.org/
  * Vagrant must be installed.
    * https://www.vagrantup.com/
  * Ansible must be installed.
    * http://www.ansible.com/
  * The Cumulus Linux module for Ansible must be installed.
    * Once Ansible is installed, this is achieved with the command ```ansible-galaxy install cumulus.CumulusLinux```
    

#### Topology
![Topology](https://github.com/slaffer-au/vx_vagrant_clag_demo/blob/master/Topology/Topology.jpg)


#### Description
  * The eth0 interface is connected to a VirtualBox NAT network for internet connectivity. 
  * CLAGs are formed as pictured above, with CLAG IP keepalive and messaging communication performed using interface _peerlink.4094_.
  * No CLAG backup IP is configured. In a real-world deployment, it is recommended to do this through the OOB network.
  * On the Spine switches, CLAG IDs 1-3 are used towards the Leaf switches. Each Leaf pair use only CLAG ID 1 towards the Spines.
  * Each switch uses a VLAN-aware bridge, trunking VLANs 1-100 with a native VLAN of 1.
  * SVIs are currently configured on VLAN 10 on all switches. The Spine switches also have VRR configured between them.
  

#### Instructions
  1. Download and/or install all the above prerequisites.
  2. Add the Cumulus VX Vagrant Box file with the name "cumulus-vx-2.5.3"
   * This is achived with the following command in the directory where the box file is placed: 
    ``` vagrant box add CumulusVX-2.5.3-4eb681f3df86c478.box --name cumulus-vx-2.5.3 ```
  2. Download or git-clone this repository.
  3. Enter the command "vagrant up" in the directory where the files were placed. This will create and provision the Cumulus VX instances.
  4. Once completed, connect to the CLI of the VX instances with "vagrant ssh ```hostname```"

