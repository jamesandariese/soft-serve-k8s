# `soft-serve-k8s`

A kustomizeable [soft-serve](https://github.com/charmbracelet/soft-serve) distribution
for hosting your Git.

To use this, you must create a kustomization of your own.  An example is available in
the examples directory.

This also expects that ports 22, 80, 443, and 9418 all are served by the same IP.  This
is easily achieved by simply using a new load balancer.  I personally have set this up
to use my apex domain and serve git http at /src.  You do _not_ need to host it at /src.

## Setup

* First, you'll need to setup your `kustomization.yaml`

* Now deploy via kubectl apply -k .
  * This will fail to actually launch anything until you've created your admin ssh key.

* !!!Ensure the load balancer has received a reachable IP before continuing!!!

* Now create your SSH key using init.sh
  * This step creates an ssh key in a kubernetes secret.
  * This step will also create an entry in your ssh config called softserve-admin
    which will point to the IP reserved in your load balancer and use the admin ssh
    key which was just placed in the kubernetes secrets.

* Test
  * `ssh softserve-admin info`

* Create an admin user
  * `ssh softserve-admin user create bobted`
  * `ssh softserve-admin user add-pubkey bobted "$(cat ~/.ssh/id_rsa.pub)"`
  * `ssh softserve-admin user add-pubkey bobted "$(cat ~/.ssh/id_ed25519.pub)"`
  * `ssh softserve-admin user set-admin bobted true`
