# Черновик деплоя k8s через kubespray

## Деплой ВМ в GCP

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Прописать в terraform.tfvars свои параметры
terrarom plan
terraform apply
```

В выводе `terraform apply` будут адреса master- и worker-нод.

## Деплой Kubernetes

В `kubespray/ansible.cfg` в блоке `defaults` установить параметр `private_key_file`

В файле `kubespray/inventory/mycluster/inventory.ini` прописать адреса master- и worker-нод.

```bash
cd kubespray
ansible-galaxy install  -c  -r ./requirements.yml # Лучше на всякий проверить версии перед установкой
ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root cluster.yml
```