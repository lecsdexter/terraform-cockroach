
#### Prerequisites

Edit this file according to you account and run it:

```sh
./1_data.sh
```

Customize this file and run it (creation of service principal):

```sh
source 2_prerequisites.sh 
```

#### Rise the infraestructure
```sh
terraform apply -auto-approve
```

#### Pre-configure each node 
```sh
cd ansible; ansible-playbook ./playbook/playbook.yml -i ./inventory/inventory.in; cd ..
```

####Configure each node 

```sh
curl https://binaries.cockroachdb.com/cockroach-v21.2.4.linux-amd64.tgz | tar -xz

sudo cp -i cockroach-v21.2.4.linux-amd64/cockroach /usr/local/bin/

sudo mkdir -p /usr/local/lib/cockroach

sudo cp -i cockroach-v21.2.4.linux-amd64/lib/libgeos.so /usr/local/lib/cockroach/

sudo cp -i cockroach-v21.2.4.linux-amd64/lib/libgeos_c.so /usr/local/lib/cockroach/

cockroach start --insecure --advertise-addr=104.45.173.87 --join=104.45.173.87,104.45.173.84,104.45.173.65 --cache=.25 --max-sql-memory=.25 --background
```

#### Test the cluster

Run in Local machine:

```sh
cockroach init --insecure --host=<address of any node on --join list>
cockroach init --insecure --host=104.45.173.87
```

Connect to the load balancer:
```sh
cockroach sql --insecure --host=<address of load balancer>
cockroach sql --insecure --host=104.45.172.221
```

Interacg with the db:
```sh
CREATE DATABASE insecurenodetest;

SHOW DATABASES;

\q
```


<!-- ####Workload node  -->

<!-- <In process...> -->

<!-- ```sh
az vm create --resource-group rg-dev-eastus-cockroach --name vm-workload --image UbuntuLTS --public-ip-sku Standard --admin-username azureuser --generate-ssh-keys 
``` -->



#### Destory the infraestructure

<!-- ```sh
az vm delete --resource-group rg-dev-eastus-cockroach --name vm-workload 
``` -->

```sh
terraform destroy -auto-approve
```


Reference: [Deploy CockroachDB on Microsoft Azure - Insecure
](https://www.cockroachlabs.com/docs/stable/deploy-cockroachdb-on-microsoft-azure-insecure.html#step-7-test-the-cluster)