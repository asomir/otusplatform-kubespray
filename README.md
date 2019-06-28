# Деплой k8s через kubespray

Кластера разворачиваем в проекте `otusplatform-kubespray`.

Создаем JSON-ключ для пользователя `terraform`.
Кладем созданный ключ под именем `account.json` в каталог `terraform`.

## Деплой ВМ

Установить [Terraform provider for Ansible](https://nbering.github.io/terraform-provider-ansible/docs/installation.html) для подключения dynamic inventory в Ansible из Terraform (состоит из 2-х частей: провайдер для Terraform и скрипт dynamic inventory для Ansible).

В `variables.tf` можно устанавливать количество master/worker-нод, etcd ставится на master-ноды.

Создаем ноды:

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

Установить переменную окружения `ANSIBLE_TF_DIR`, указывающую путь к рабочей директории terraform.

Разворачивем k8s кластер:

```bash
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
export ANSIBLE_TF_DIR=../terraform
ansible-playbook -i /etc/ansible/terraform.py --become --become-user=root --user=user --key-file=~/.ssh id_rsa_otusplatform_kubespray cluster.yml
```