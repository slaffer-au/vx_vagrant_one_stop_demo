# Cumulus VX - One Stop Demo
### _A two-tier, nine switch topology of Cumulus VX switches and three Ubuntu hosts with a range of topologies which can be deployed with Ansible automation.


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
    

#### Network Diagram
![Topology](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/raw-topology.png)


#### Instructions
  1. Download and/or install all the above prerequisites.
  2. Add the Cumulus VX Vagrant Box file with the name "cumulus-vx-2.5.3"
   * This is achived with the following command in the directory where the box file is placed: 
    ``` vagrant box add CumulusVX-2.5.3-4eb681f3df86c478.box --name cumulus-vx-2.5.3 ```
  2. Download or git-clone this repository.
  3. Enter the command "vagrant up" in the directory where the files were placed. This will create and provision the Cumulus VX instances.
  4. Once completed, connect to the CLI of the VX instances with "vagrant ssh ```hostname```"

