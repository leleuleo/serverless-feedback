import json
import boto3
import os
import uuid

# Inicializa os serviços AWS
dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

table_name = os.environ['DYNAMODB_TABLE']
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    method = event['httpMethod']
    
    if method == 'POST':
        # Criar um novo feedback
        body = json.loads(event['body'])
        feedback_id = str(uuid.uuid4())

        item = {
            'id': feedback_id,
            'usuario': body.get('usuario'),
            'mensagem': body.get('mensagem'),
            'data': body.get('data')
        }

        table.put_item(Item=item)

        # Enviar notificação para SNS
        message = f"Novo feedback recebido de {body.get('usuario')}:\n{body.get('mensagem')}"
        sns.publish(
            TopicArn=sns_topic_arn,
            Message=message,
            Subject="Novo Feedback Registrado"
        )

        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'Feedback cadastrado e notificação enviada!', 'id': feedback_id})
        }

    elif method == 'GET':
        # Listar feedbacks
        response = table.scan()
        items = response.get('Items', [])

        return {
            'statusCode': 200,
            'body': json.dumps(items)
        }

    else:
        return {
            'statusCode': 405,
            'body': json.dumps({'message': 'Método não permitido'})
        }
