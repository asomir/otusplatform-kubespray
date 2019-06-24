# Черновик деплоя k8s через kubespray

## Деплой ВМ в GCP

Установить [Terraform provider for Ansible](https://nbering.github.io/terraform-provider-ansible/docs/installation.html) для подключения dynamic inventory в Ansible из Terraform (состоит из 2-х частей: провайдер для Terraform и скрипт dynamic inventory для Ansible).

В каталог `terraform` положить ключ `account.json`.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Прописать в terraform.tfvars свои параметры
terraform init
terraform plan
terraform apply
```

В выводе `terraform apply` будут адреса master- и worker-нод.

## Деплой Kubernetes

В `kubespray/ansible.cfg` в блоке `defaults` установить параметр `private_key_file`

Установить переменную окружения `ANSIBLE_TF_DIR`, указывающую путь к рабочей директории terraform.

```bash
cd kubespray
export ANSIBLE_TF_DIR=../terraform
ansible-galaxy install  -c  -r ./requirements.yml # Лучше на всякий проверить версии перед установкой
ansible-playbook -i /etc/ansible/terraform.py --become --become-user=root cluster.yml
```