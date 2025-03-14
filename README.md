🚀 Projeto Serverless Feedback
Este projeto implementa uma arquitetura Serverless na AWS utilizando Terraform.

Ele provisiona automaticamente API Gateway, AWS Lambda, DynamoDB e SNS para processar feedbacks de usuários.

📁 Estrutura do Projeto
📌 O código está organizado da seguinte maneira:


```
/serverless-feedback
│── /infra                # Código Terraform (Infraestrutura como código)
│   ├── api_gateway.tf    # API Gateway
│   ├── dynamodb.tf       # DynamoDB
│   ├── lambda.tf         # Lambda
│   ├── sns.tf            # SNS
│   ├── main.tf           # Configuração global do Terraform
│   ├── outputs.tf        # Definição dos Outputs do Terraform
│── /lambda               # Código da função Lambda
│   ├── lambda_function.py
│── /tests                # Testes para a API (opcional)
│   ├── test-api.http
│── /docs                 # Diagramas e documentação
│   ├── diagrama_feedback.drawio
│── .gitignore            # Arquivos ignorados pelo Git
│── README.md             # Descrição do projeto
🔧 Pré-requisitos
```
Antes de rodar o projeto, certifique-se de ter instalado:

✅ AWS CLI (Download)
✅ Terraform (Download)
✅ Git (Download)
Se ainda não configurou a AWS CLI, execute:

```powershell
aws configure
```
Isso solicitará suas credenciais da AWS (Access Key e Secret Key).

🔑 Concedendo Permissões ao Usuário Terraform
Antes de executar o Terraform, o usuário terraform precisa ter permissões para criar recursos na AWS.

Caso ainda não tenha configurado as permissões, execute os comandos abaixo no AWS CLI com um usuário que tenha permissões administrativas:

```powershell
aws iam attach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator
aws iam attach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess
aws iam attach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/IAMFullAccess
aws iam attach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AWSLambda_FullAccess
aws iam attach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AmazonSNSFullAccess
```

📌 Essas permissões permitem que o Terraform crie e gerencie os seguintes serviços:

API Gateway → AmazonAPIGatewayAdministrator
DynamoDB → AmazonDynamoDBFullAccess
IAM (para roles da Lambda) → IAMFullAccess
Lambda → AWSLambda_FullAccess
SNS (para envio de notificações) → AmazonSNSFullAccess
Se quiser validar as permissões associadas ao usuário terraform, rode:

```powershell
aws iam list-attached-user-policies --user-name terraform
```
Isso mostrará todas as políticas que estão vinculadas ao usuário.

🚀 Passo a Passo para Deploy
1️⃣ Configurar AWS CLI
Se ainda não fez isso, configure suas credenciais AWS:

```powershell
aws configure
```
2️⃣ Inicializar o Terraform
Antes de criar os recursos na AWS, execute:

```powershell
cd infra
terraform init
```
Isso fará o download dos plugins necessários.

3️⃣ Aplicar o Terraform (Criar Infraestrutura)
Agora, rode o Terraform para provisionar os recursos:

```powershell
terraform apply -auto-approve
```

📌 Após a execução, a URL do API Gateway será exibida no final do terminal.

4️⃣ Testar a API
Agora, com a infraestrutura criada, teste a API com um POST:

```powershell
curl -X POST https://SEU_API_ID.execute-api.us-east-1.amazonaws.com/prod/feedback `
-H "Content-Type: application/json" `
-d "{ \"usuario\": \"Maria\", \"mensagem\": \"Ótimo serviço!\", \"data\": \"2025-03-14\" }"
Ou, se estiver usando o arquivo test-api.http, basta rodar:
```

```powershell
code test-api.http
```

E enviar a requisição pelo VS Code.

5️⃣ Verificar os Dados no DynamoDB
Para visualizar os feedbacks salvos, rode:

```powershell
aws dynamodb scan --table-name Feedbacks
```

Isso listará todos os itens armazenados no DynamoDB.

📌 Componentes da Infraestrutura
✅ API Gateway → Exposição da API.
✅ Lambda → Processamento das requisições.
✅ DynamoDB → Armazenamento dos feedbacks.
✅ SNS → Notificações quando um feedback é registrado.

📌 Como Deletar Todos os Recursos
Caso queira remover toda a infraestrutura provisionada:

```powershell
terraform destroy -auto-approve
```

Isso apagará todos os recursos criados na AWS.

📌 Contribuições
Se quiser melhorar este projeto, sinta-se à vontade para abrir issues ou fazer pull requests.

📜 Licença
Este projeto é de código aberto e distribuído sob a licença MIT.