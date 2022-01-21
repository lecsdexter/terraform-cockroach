output "vms_IPs" {
    value = "${module.virtualmachine.*.vm_ip}"
}

output "lb_IP" {
    value = "${module.loadbalancer.lb_ip}"
}

// output "vms_IPS_2" {
//   value     = [for i in module.virtualmachine : "${i.vm_ip}"] 
// }
