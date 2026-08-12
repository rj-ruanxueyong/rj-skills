Ruijie(config)#show route-res usage all
Switch  Slot    Switch-Mode-Current      Switch-Mode-Next         
----------------------------------------------------------------------------------------
1       0       default                  default                  
----------------------------------------------------------------------------------------
L3 Software Statistics:
-----------------------
Switch  Slot    Chip    Name            Used    Description                     
----------------------------------------------------------------------------------------
1       0       0       IPv4_LPM        0       ipv4 route in lpm table         
1       0       0       IPv4_HOST       0       ipv4 route in l3_entry table    
1       0       0       IPv6_64_LPM     2       ipv6-64 route in lpm table      
1       0       0       IPv6_128_LPM    0       ipv6-65-128 route in lpm table  
1       0       0       IPv6_HOST       0       ipv6 route in l3_entry table    
----------------------------------------------------------------------------------------
Switch  Slot    Chip    Name            Used    Max     Description                     
----------------------------------------------------------------------------------------
1       0       0       NEXTHOP         118     147456  nexthop number                  
1       0       0       NEXTHOP_1       0       8192    nexthop phase 1 number         
1       0       0       NEXTHOP_2       8       153782  nexthop phase 2 number         
1       0       0       NEXTHOP_3       38      32767   nexthop phase 3 number         
1       0       0       NEXTHOP_4       1       1       nexthop phase 4 number         
1       0       0       NEXTHOP_5       0       4094    nexthop phase 5 number         
1       0       0       NEXTHOP_6       18      9216    nexthop phase 6 number         
1       0       0       NEXTHOP_7       23      163838  nexthop phase 7 number         
1       0       0       ECMP_GROUP      10      6143    ecmp group number               
1       0       0       ECMP_GROUP_1    14      14336   ecmp group phase 1 number      
1       0       0       ECMP_GROUP_2    4       4096    ecmp group phase 2 number      
1       0       0       ECMP_GROUP_3    8       8192    ecmp group phase 3 number      
1       0       0       ENCAP           30      81920   encap number                    
----------------------------------------------------------------------------------------

L3 Forwarding Statistics:
-------------------------
Switch  Slot    Chip    Service      Resource      Max        Used    
----------------------------------------------------------------------------------------
1       0       0       IPV4                       1500000    0       
                                     LPM                      0       
1       0       0       IPV4_32                    1500000    0       
                                     LEM                      0       
                                     LPM                      0       
1       0       0       IPV6_64                    1500000    2       
                                     LPM                      2       
1       0       0       IPV6_127                   1500000    0       
                                     LPM                      0       
1       0       0       IPV6_128                   1500000    0       
                                     LEM                      0       
                                     LPM                      0       
----------------------------------------------------------------------------------------


Ruijie(config)#show ip ref route detail 1.1.1.1
IPv4 001.001.001.001/32 vrf:0
=============================== SSC INFO ===============================
      ifx   nh_ip                pri w   mac              cmd        vid   l2_ifx sub_port main_vid rt_type  rt_own  
 [ 0] 14    001.001.000.002      0   1   0000.0000.1234   forward    0     0      0        0        network  comm    
 [ 1] 15    001.002.000.002      0   5   0000.0000.1111   forward    0     0      0        0        network  comm    
 [ 2] 15    001.002.000.003      0   2   0000.0000.1234   forward    0     0      0        0        network  comm    
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ SSC END ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

=============================== SSD INFO ===============================
***** LC slot 1/0 ROUTE INFO *****
 prefix_type nh_id  ecmp_gid owner            ecmp_ready    nhblk_id             nh_id  nhblk_ready
 lpm         10     6        comm             1             145                  10     1          

      ifx   ip                   intf_id phyid      vlan  cmd        flow_id  mac              adj_id in_adj_id nhitem_id nh_status
 [ 0] 14    001.001.000.002      4094    0x70009c0  4094  forward    0        0000.0000.1234   16416  0         0         1        
 [ 1] 15    001.002.000.002      4093    0x70009c1  4093  forward    0        0000.0000.1111   16417  0         0         1        
 [ 2] 15    001.002.000.003      4093    0x70009c1  4093  forward    0        0000.0000.1234   16418  0         0         1        
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ SSD END ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

=============================== SSA INFO ===============================
IPv4 001.001.001.001/32 vrf:0
***** LC slot 1/0 ROUTE INFO *****
[unit:0] hw_type  ecmp_gid  ecmp_base|sz  entry_base|sz  classid  flags      is_ext  hit   
         lpm      6                10|3            0|0   4        0x0        0       [0]0  

NHOP:  nh_id  phase  type  phyid      intf_id  act   enc_id  flow_id  dmac            evlan  vni  tag_act  eport      modid  port       tgid
 [ 0]  10     7      0     0x70009c0  4094     F(2)  16416   0        0000.0000.1234  4094   0    0        0x0        0      0x6c0001c0   0
 [ 1]  11     7      0     0x70009c1  4093     F(2)  16417   0        0000.0000.1111  4093   0    0        0x0        0      0x6c0001c1   0
 [ 2]  12     7      0     0x70009c1  4093     F(2)  16418   0        0000.0000.1234  4093   0    0        0x0        0      0x6c0001c1   0
L3OIF: hw_id  evlan  tnl_idx  is_mpls_tnl  ttl   mtu  smac
 [ 0]  16416  4094   0        0            0     9216 004a.a436.949a
 [ 1]  16417  4093   0        0            0     9216 004a.a436.949a
 [ 2]  16418  4093   0        0            0     9216 004a.a436.949a

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ SSA END ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^