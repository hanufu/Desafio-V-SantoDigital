# Desafio-V-SantoDigital
Automação de Infraestrutura com Terraform

## Justificativas de Configuração
Tipo de instância (e2-micro): Escolhemos o tipo e2-micro por ser econômico e adequado para cargas de trabalho leves, como um servidor Apache.
Sub-redes: Criamos sub-redes em diferentes regiões (us-central1 e us-east1) para simular uma distribuição geográfica dos servidores, fornecendo maior resiliência.
Balanceador de Carga: Um balanceador HTTP(S) garante alta disponibilidade e escalabilidade ao distribuir o tráfego entre as VMs.
Regras de Firewall: Permitir o tráfego HTTP (porta 80) para garantir que as VMs e o balanceador de carga possam ser acessados pela web.

## Instruções para Aplicação
Autenticação no GCP:

* Instale o gcloud CLI e autentique-se com gcloud auth login.
* Configure o projeto desejado com gcloud config set project <PROJECT_ID>.

### Inicializar o Terraform:

No diretório contendo os arquivos, inicialize o Terraform:
```bash
terraform init
```
### Verificar o Plano:

Execute o comando abaixo para visualizar os recursos que serão criados:

```bash
terraform plan
```
## Aplicar as Configurações:

### Aplique o plano para criar os recursos:
```bash
terraform apply
```
## Verificar a Criação:

Após a execução, o IP do balanceador de carga será exibido. Acesse esse IP no navegador para verificar se o Apache está servindo as páginas das VMs.
### Destruir os Recursos:

Após a verificação, destrua os recursos com:
```bash
terraform destroy
````

## Conclusão
Esses arquivos de configuração provisionam uma infraestrutura básica no GCP usando Terraform. A configuração oferece uma rede VPC distribuída em duas regiões, VMs com servidores Apache, e um balanceador de carga HTTP(S). As regras de firewall garantem que o tráfego seja permitido, enquanto o balanceador de carga distribui o tráfego entre as instâncias para garantir alta disponibilidade.
