## Automated Topology Deployments Using Ansible

#### Notes on the Automation:
Vagrant creates a NAT network with eth0 of all Cumulus VX and Ubuntu boxes, forwarding a localhost TCP port to port 22 of the guest for SSH access. This is how the wrapper ```vagrant ssh <vm>``` works.

While this works well for purely local SSH access, it inherently makes it hard to connect and develop with these devices as if they were actual remote network nodes. If you do want the ```ssh vagrant@vm``` style access expected of real hosts, consider using the Vagrant-to-Local script available at the following link. This is **not** required for this demo.

* https://github.com/slaffer-au/vagrant-to-local

##### Setting Up for Automation
1. Change to the automation directory
2. Ensure all hosts are accessible by Ansible with the ad-hoc command ```ansible all -m ping -u vagrant```.


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
1. Ensure "spine3" is commented out in the ```hosts``` file.
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

#### BGP Unnumbered:
*eBGP Topology:*
![Topology](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/ebgp-unnum-topology-9s.png)
*iBGP Topology:*
![Topology](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/ibgp-unnum-topology-9s.png)

##### Description:
Like the OSPF example above, BGP unnumbered is also supported in the Cumulus Linux distribution of the Quagga routing suite.

This topology demonstrates a deployment of both eBGP and iBGP Unnumbered using Quagga, Cumulus Link Aggregation (CLAG) and Cumulus Virtual Router Redundancy (VRR).
  * http://docs.cumulusnetworks.com/display/DOCS/Configuring+Border+Gateway+Protocol+-+BGP
  * http://docs.cumulusnetworks.com/display/DOCS/Multi-Chassis+Link+Aggregation+-+MLAG
  * http://docs.cumulusnetworks.com/display/DOCS/Virtual+Router+Redundancy+-+VRR

##### Details:
  * All hosts are assigned a loopback address. The same address is also assigned to the unnumbered interfaces between Leaf and Spine.
  * BGP is configured on all unnumbered interfaces, rather than with an IPv4 neighbor statement.
  * The BGP peer-group is configured with extended next-hop encoding and ```remote-as external``` or ```remote-as internal``` based on the demo.
  * All hosts advertise their loopbacks into BGP. All Leaf switches advertise their locally connected VLAN 10 subnet as pictured. SVIs and VRR is configured on VLAN 10 on all Leaf switches.
  * The Leaf to Host CLAG topology is retained, with CLAG ID 5 being configured to the hosts. Each Leaf switch maintains a VLAN-aware bridge, trunking VLANs 1-100 with a native VLAN of 1.
  * The hosts are configured with a VLAN 10 address unique to their attached Leaf pair as pictured.
  * Hosts host12 and host34 also have an address of `70.70.1.1` to emulate an anycast application. This host route is also advertised into BGP by leaf1-4 by a filtered redistribution of static routes. 
  * Host host56 maintains a static route to this anycast prefix with a next-hop of its local VRR address. 
  * For security, hosts do not have routes to the "infrastructure" subnets by design. While traffic will reach the hosts from the unnumbered infrastucture, hosts will only respond to addresses in the ```10.0.0.0/8``` range.
  
##### Deployment:
1. Run the Ansible playbook with the command ```ansible-playbook ebgp-unnum.yml``` or ```ansible-playbook ibgp-unnum.yml```.
2. If a nine switch topology is desired, uncomment "spine3" from the hosts file and run the Ansible playbook again to provision spine3.

---  

#### VxLAN with LNV:
*VxLAN Topology:*
![Topology](https://github.com/slaffer-au/vx_vagrant_one_stop_demo/blob/master/Topology/vxlan-topology-9s.png)

##### Description:
_This topology is designed to be deployed after the OSPF or BGP examples above as it relies on a routed IP fabric._

The biggest trend in Data Center networking right now is towards virtual network overlay technologies such as VxLAN. VxLAN is an open standard MAC-in-UDP encapsulation technology which allows a Layer 2 broadcast domain to extend over a Layer 3 infrastructure. By encapsultaing in IP and leveraging Equal Cost Multi-Path (ECMP), VxLAN enables a highly fault tolerant, full bandwidth physical network for the overlayed, Layer 2 Virtual Network (VNI), signified with its own Virtual Network Identifier (VNID).

In this topology, the leaf switches are acting as the termination points of the VxLAN tunnels (known as a VxLAN Tunnel End Point or VTEP), thus becoming the gateway between the traditional Layer 2 and the VxLAN networks. As the switches are running CLAG, VxLAN Active-Active mode allows a pair of MLAG switches to act as a single VTEP, providing active-active VxLAN termination.

Also deployed in this topology is Lightweight Network Virtualization (LNV), a technique for deploying VNIs on switches without a centralised controller. LNV includes simple VxLAN service and registration daemons which run on Cumulus Linux itself, allowing easy distribution of VNI information to VTEPs.

This topology demonstrates a deployment of VxLAN using Lightweight Network Virtualization, including a distributed anycast service node, and VxLAN Active-Active mode in conjunction with CLAG. VNIs are deployed using the traditional bridging driver.

  * https://docs.cumulusnetworks.com/display/DOCS/Network+Virtualization
  * https://docs.cumulusnetworks.com/display/DOCS/Lightweight+Network+Virtualization+-+LNV
  * https://docs.cumulusnetworks.com/display/DOCS/VXLAN+Active-Active+Mode
  * http://docs.cumulusnetworks.com/display/DOCS/Multi-Chassis+Link+Aggregation+-+MLAG


##### Details:
  * A routed IP fabric has been deployed previously through one of the above demonstrations.
  * Each switch uses its loopback address as the VTEP address for single-attached orphan connections.
  * A shared address is deployed on the loopback of each leaf switch pair. This is used as the Active-Active mode VTEP address for all dual-connected hosts.
  * VNI interfaces are deployed on the leaf switches as required. ```VNI 20``` and ```VNI 400``` are deployed on all leaf switches, while ```VNI 3000``` is deployed on leaf1-2 and leaf5-6 only.
  * Traditional bridges are deployed on the leaf switches. 
   * The VNI interface and any local interfaces are configured as bridge member ports, providing the translation from VxLAN to VLAN.
   * Importantly, this is locally significant to the port, meaning that the VNI 400 broadcast domain is ```VLAN 40``` on leaf1-2, ```VLAN 80``` on leaf3-4 and ```VLAN 48``` on leaf5-6. 
   * Below is an extract from the Ansible automation variables used in the deployment. 
``` 
    vni_400:
      vnid: 400
      hosts:
        leaf1:
          vlan_id: 40
          members: "host_clag"
        leaf2:
          vlan_id: 40
          members: "host_clag"
        leaf3:
          vlan_id: 80
          members: "host_clag"
        leaf4:
          vlan_id: 80
          members: "host_clag"
        leaf5:
          vlan_id: 48
          members: "host_clag"
        leaf6:
          vlan_id: 48
          members: "host_clag"
```
  * The VxLAN Registration Daemon (```vxrd```) is deployed and started on the leaf switches, with the service node address set to the anycast address of ```100.254.254.254```.
  * The service node anycast address is added to the loopback of the spine switches.
  * The service node anycast address is advertised into the routing protocol of choice by the spines.
  * The leaf active-active addresses are advertised into the routing protocol of choice by the leaf switches.
  * Additionally based on the routing protocol, to facilitate ```vxsnd``` fdb distribution between the spines:
   * eBGP: On the spines, the ```allowas-in``` parameter is set for the peer-group.
   * iBGP: On the leaf switches, they are configured ```route-reflector-client``` and ```next-hop-self``` for the peer-group. Additionally, ```maximum-paths-ibgp set 64 equal-cluster-length``` is configured so BGP takes cluster-list length into the multipath calculation.
  * The VxLAN Service Node Daemon (```vxsnd```) is deployed and started on the spine switches and bound to the anycast address.
  

##### Deployment:
1. Ensure one of the above routing topologies has been deployed successfully.
2. Edit the routing_protocol section of the file ```group_vars/all/vxlan.yml``` to reflect which protocol is in use. The example below deploys VxLAN on an eBGP fabric.
```
 8     routing_protocol:
 9        ebgp: True
 10       ibgp: False
 11       ospf: False
```
3. Run the Ansible playbook with the command ```ansible-playbook vxlan.yml```.
2. If a nine switch topology is desired, uncomment "spine3" from the hosts file and run the Ansible playbook again to provision spine3.
