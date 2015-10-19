# Cumulus VX - One Stop Demo
### _A two-tier, nine switch topology of Cumulus VX switches and three Ubuntu hosts with a range of topologies which can be deployed with Ansible automation._

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
    

#### Raw Network Diagrams
Some topologies only require 8 switches, such as the Two-Tier-CLAG. Other topologies can make use of a third spine, however this is usually an extended automation task.

*8 Switch Topology:*
![Topology](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/raw-topology.png)
*9 Switch Topology:*
![Topology-9s](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/raw-topology-9s.png)


#### Setup Instructions
  1. Download and/or install all the above prerequisites.
  2. Add the Cumulus VX Vagrant Box file with the name "cumulus-vx-2.5.3"
   * This is achived with the following command in the directory where the box file is placed: 
    ``` vagrant box add CumulusVX-2.5.3-4eb681f3df86c478.box --name cumulus-vx-2.5.3 ```
  3. Add the Ubuntu Trusty64 Vagrant box file. This add command downloads the box from the public Vagrant Box catalogue.
   * ``` vagrant box add ubuntu/trusty64 ```
  4. Download or git-clone this repository.
  5. Enter the command "vagrant up" in the directory where the files were placed. This will create and provision the Cumulus VX instances.
  6. Once completed, connect to the CLI of the VX instances with "vagrant ssh ```hostname```"

#### Ansible Automation
All automation instuctions and examples are available in the [automation](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/tree/master/automation) directory.

##### Side note:
Vagrant creates a NAT network with eth0 of all Cumulus VX and Ubuntu images, forwarding a localhost port to TCP port 22 of the guest for SSH access. While this works well for purely local SSH access, it inherently makes it hard to connect and develop with these devices as if they were actual remote network nodes.

With that in mind, all Ansible automation has been built around having a local SSH alias for each VX, thus allowing "ssh vagrant@vm" access expected of real hosts. This is achieved through the Vagrant-to-Local script available at the following link.

https://github.com/slaffer-au/vagrant-to-local



