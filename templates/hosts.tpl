[all:vars]
ansible_connection=ssh
ansible_user=${ users }
ansible_ssh_pass=${ pwds }
[all]
%{ for ip in vm_ips ~}
${ip}
%{ endfor ~}