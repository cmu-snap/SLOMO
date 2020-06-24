# SLOMO
Material for SLOMO performance prediction framework presented at SIGCOMM 2020

## **Hardware & OS**

We use two machines for our experiments, one for hosting NFs and another for traffic generation.  Below we describe two such hardware setups. 

**Setup 1** 

* _CPU_: Intel Xeon E5-2620 v4
* _NIC _: Intel XL710 - 40GbE QSFP+ 1584 (2 NICs/server)

* _OS_: Ubuntu 18.04.3 LTS - 4.15.0-99-generic
* _DPDK_:  18.05.1 stable
* _NIC Drivers_: i40e-2.9.21 - iavf-3.7.53


**Setup 2**

* *CPU*: Intel Xeon Silver 4110 
* *NIC*: Mellanox MT27700 Family [ConnectX-4] 1013 (2 NICs/server)

* *OS*: Ubuntu 18.04.2 LTS - 4.15.0-48-generic
* *DPDK*:  18.11.1 stable
* *NIC Drivers*: MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64


**Note:**

* Each port on the generator is directly attached to the corresponding physical port of the testing server.
* Ideally, both machines should be dual-socket with high core count processors. Hyper-threading should be deactivated.
* The specific driver NICs were necessary to ensure that DPDK would work seamlessly on top of SR-IOV.


## **Installation - Setup**

* <>  contains basic installation routines.
* The NFs we used in our work rely on DPDK for I/O.  
* <> is a script that partitions each physical NIC to multiple virtual ports using SR-IOV. Please ensure that your NIC’s VF drivers are updated and that a compatible version of DPDK is being used.
* Please ensure that NFs will be spawned on cores of the same CPU socket as the NIC they will be receiving traffic from to avoid unnecessary communication over QPI. 

