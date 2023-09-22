ssh -o StrictHostKeyChecking=no -i ${private_key_local_path} -N -L ${local_port}:${server_private_ip}:22 -p 22 ${bastion_session_ocid}@host.bastion.${bastion_region_id}.oci.oraclecloud.com &
tunnel_pid=$!
sleep 2
ssh -o StrictHostKeyChecking=no -i ${private_key_local_path} -p ${local_port} -t ubuntu@localhost 'cat /etc/rancher/k3s/k3s.yaml'
kill $tunnel_pid
