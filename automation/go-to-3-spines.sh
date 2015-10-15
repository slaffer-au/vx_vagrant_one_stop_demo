 sed -i.bak s/#// hosts 
 sed -i.bak s/"\/ospf.yml"/"\/3spine-ospf.yml"/g ospf-unnum.yml 
  
  
  
echo "
###############################
#     Diffs in hosts file     #
###############################
"
diff hosts hosts.bak 
echo "
###############################
#      Diffs in playbook      #
###############################
"
diff ospf-unnum.yml ospf-unnum.yml.bak 
echo "
###############################
#      Diffs in variables     #
###############################
"
diff group_vars/all/ospf.yml group_vars/all/3spine-ospf.yml
