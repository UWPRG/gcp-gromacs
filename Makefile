GMX_NAME ?= "gcp-gromacs"
GMX_PROJECT ?= "biomolecular-sims"
GMX_ZONE ?= "us-west1-b"
GMX_MACHINE_TYPE ?= "n1-standard-8"
GMX_NODE_COUNT ?= 1
GMX_IMAGE ?= "us.gcr.io/biomolecular-sims/gromacs_2021.2:v1"
GMX_GPU_TYPE ?= "nvidia-tesla-v100"
GMX_GPU_COUNT ?= 1

.PHONY: plan apply destroy

basic.tfvars: basic.tfvars.tmpl
	cp basic.tfvars.tmpl basic.tfvars
	sed -i "s/<name>/${GMX_NAME}/g" basic.tfvars
	sed -i "s/<project>/${GMX_PROJECT}/g" basic.tfvars
	sed -i "s/<zone>/${GMX_ZONE}/g" basic.tfvars
	sed -i "s/<machine_type>/${GMX_MACHINE_TYPE}/g" basic.tfvars
	sed -i "s/<node_count>/${GMX_NODE_COUNT}/g" basic.tfvars
	sed -i "s#<image>#${GMX_IMAGE}#g" basic.tfvars
	sed -i "s/<gpu_type>/${GMX_GPU_TYPE}/g" basic.tfvars
	sed -i "s/<gpu_count>/${GMX_GPU_COUNT}/g" basic.tfvars

.terraform: 
		terraform init

plan: basic.tfvars .terraform
		terraform plan -var-file=basic.tfvars -out terraform.tfplan

apply: plan
		terraform apply -var-file=basic.tfvars -auto-approve

destroy:
		terraform destroy -var-file=basic.tfvars -auto-approve
