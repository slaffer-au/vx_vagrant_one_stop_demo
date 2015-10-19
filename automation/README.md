## Automated Topology Deployments Using Ansible

#### Notes on the Automation:
Vagrant creates a NAT network with eth0 of all Cumulus VX and Ubuntu boxes, forwarding a localhost TCP port to port 22 of the guest for SSH access. This is how the wrapper ```vagrant ssh <vm>``` works.

While this works well for purely local SSH access, it inherently makes it hard to connect and develop with these devices as if they were actual remote network nodes.

With that in mind, all Ansible automation has been built around having a local SSH alias for each VX, thus allowing ```ssh vagrant@vm``` access expected of real hosts. This is achieved through the Vagrant-to-Local script available at the following link.

* https://github.com/slaffer-au/vagrant-to-local

##### Setting Up for Automation
1. Download or git-clone the Vagrant-to-Local script into the directory with the Vagrantfile.
2. Run the script with ```./v2l.py``` or ```python v2l.py```. A list of SSH aliases will be printed to the screen.
3. Change to the automation directory
4. Ensure all hosts are accessible by Ansible with the ad-hoc command ```ansible all -m ping -u vagrant```.


---


#### Two-Tier CLAG:
![Topology](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/two-tier-clag-topology.png)

##### Description:
A common deployment seen in data centers involves Multi-Chassis Link Aggregation, or MLAG, where two switches with independant control-planes emulate a single logical device to directly connected devices, allowing a more complete use of bandwidth and available redundancy.

This topology demonstrates a deployment of Cumulus Link Aggregation (CLAG) and Cumulus Virtual Router Redundancy (VRR).
  * http://docs.cumulusnetworks.com/display/DOCS/Multi-Chassis+Link+Aggregation+-+MLAG
  * http://docs.cumulusnetworks.com/display/DOCS/Virtual+Router+Redundancy+-+VRR

##### Details:
  * CLAGs are formed as pictured above, with CLAG IP keepalive and messaging communication performed using interface _peerlink.4094_.
  * No CLAG backup IP is configured. In a real-world deployment, it is recommended to do this through the OOB network.
  * On the Spine switches, CLAG IDs 1-3 are used towards the Leaf switches. Each Leaf pair use only CLAG ID 1 towards the Spines.
  * A CLAG ID 5 is configured to the hosts. The hosts's bond interface is named "bond0".
  * Each switch uses a VLAN-aware bridge, trunking VLANs 1-100 with a native VLAN of 1.
  * SVIs are configured on VLAN 10 on all switches. The Spine switches also have VRR configured between them in VLAN 10 to provide gateway redundancy for the hosts.
  * The hosts are configured with a VLAN 10 address and an address in the native VLAN (not pictured).
  
##### Deployment:
1. Ensure "spine3" is commented out in the hosts file.
2. Run the Ansible playbook with the command ```ansible-playbook two-tier-clag.yml```.

---  

#### OSPF Unnumbered:
![Topology](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/ospf-unnum-topology-9s.png)

##### Description:
Cumulus Linux supports provisioning systems in an "unnumbered" fashion as a way to limit address space consumption. More precisely, this method is one where you can reuse the IP address assigned to the loopback on your point-to-point links to neighboring nodes.

This topology demonstrates a deployment of OSPF Unnumbered using Quagga, Cumulus Link Aggregation (CLAG) and Cumulus Virtual Router Redundancy (VRR).
  * http://docs.cumulusnetworks.com/display/DOCS/Open+Shortest+Path+First+-+OSPF+-+Protocol
  * https://support.cumulusnetworks.com/hc/en-us/articles/202796476-OSPF-Unnumbered-Sample-Configurations
  * http://docs.cumulusnetworks.com/display/DOCS/Multi-Chassis+Link+Aggregation+-+MLAG
  * http://docs.cumulusnetworks.com/display/DOCS/Virtual+Router+Redundancy+-+VRR

##### Details:
  * All hosts are assigned a loopback address. The same address is also assigned to the unnumbered interfaces between Leaf and Spine.
  * OSPF point-to-point links are configured on all unnumbered interfaces in OSPF Area 0.
  * All hosts advertise their loopbacks into OSPF. All Leaf switches advertise their locally connected VLAN 10 subnet as pictured. SVIs and VRR is configured on VLAN 10 on all Leaf switches.
  * The Leaf to Host CLAG topology is retained, with CLAG ID 5 being configured to the hosts. Each Leaf switch maintains a VLAN-aware bridge, trunking VLANs 1-100 with a native VLAN of 1.
  * The hosts are configured with a VLAN 10 address unique to their attached Leaf pair as pictured.
  * Hosts host12 and host34 also have an address of `70.70.1.1` to emulate an anycast application. This host route is also advertised into OSPF by leaf1-4 by a filtered redistribution of static routes. 
  * Host host56 maintains a static route to this anycast prefix with a next-hop of its local VRR address. 
  * For security, hosts do not have routes to the "infrastructure" subnets by design. While traffic will reach the hosts from the unnumbered infrastucture, hosts will only respond to addresses in the ```10.0.0.0/8``` range.
  
##### Deployment:
1. Run the Ansible playbook with the command ```ansible-playbook ospf-unnum.yml```.
2. If a nine switch topology is desired, uncomment "spine3" from the hosts file and run the Ansible playbook again to provision spine3.

---  
