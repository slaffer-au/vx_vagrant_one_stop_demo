# Cumulus VX - One Stop Demo
### _A two-tier, nine switch topology of Cumulus VX switches and three Ubuntu hosts with a range of topologies which can be deployed with Ansible automation._

### Tools Used 
This has been developed and tested on Mac OSX. All tools used are also available and used the same way on major Linux distributions. VirtualBox and Vagrant are available natively in Windows, however Ansible is not. There are [guides](https://servercheck.in/blog/running-ansible-within-windows) on how to get Ansible working on Windows using Cygwin, but this has not been tested. If possible, use OSX or Linux for this demo.

##### Cumulus VX:
Cumulus Linux is unleashing the power of Open Networking with a network operating system that runs on top of industry standard networking hardware. This demonstration utilises Cumulus VX, a community-supported virtual appliance that enables cloud admins and network engineers to preview and test Cumulus Networks technology at zero cost.

##### VirtualBox:
VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use. It is being used as the underlying hypervisor to virutalize Cumulus VX.

##### Vagrant:
Vagrant is a tool used to create and configure lightweight, reproducible, and portable development environments. _[In my own words]_ Instead of deploying a fully prepared virtual hard-drive file (```.ova```, ```.vmdk```, etc) which must be configured uniquely like most virtualization environments, Vagrant utilises a ```.box``` file. The ```.box``` file is more akin to a computer which has been imaged, but no user has logged in to create local customisations. A ```Vagrantfile``` is then used to define how these boxes are created, provisioned and networked together. Vagrant is used to deploy and network the Cumulus VX instances in the VirtualBox hypervisor.

##### Ansible:
Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates. Unlike other automation tools, Ansible requires no agent to be installed on the device being configured, instead simply using SSH. Ansible automation performs some basic provisioning tasks as part of the "vagrant up" and is later used to deploy the topologies.


#### Prerequisites
  * Download the Cumulus VX file for Vagrant Box.
   * https://cumulusnetworks.com/cumulus-vx/download/
  * VirtualBox must be installed.
    * https://www.virtualbox.org/
  * Vagrant must be installed.
    * https://www.vagrantup.com/
  * Ansible must be installed using PIP or APT.
    * http://www.ansible.com/
  * The Cumulus Linux module for Ansible must be installed.
    * Once Ansible is installed, this is achieved with the command ```ansible-galaxy install cumulus.CumulusLinux```
  * The Cumulux VX Vagrant Plugin must be installed.
    * Once Vagrant is installed, this is achieved with the command ```vagrant plugin install vagrant-cumulus```
    

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
All automation instuctions and examples are available in the [automation](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/tree/master/automation) directory. Change to this directory to begin deploying the topologies.





