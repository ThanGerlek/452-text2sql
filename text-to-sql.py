import json
import os

import mysql.connector
from dotenv import load_dotenv
from openai import OpenAI
from openai.types.chat.chat_completion_message_tool_call import Function

verbose = False

load_dotenv()

client = OpenAI()
mydb = mysql.connector.connect(
        host=os.getenv('MYSQL_HOST'),
        port=os.getenv('MYSQL_PORT'),
        user=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD'),
        database=os.getenv('MYSQL_DATABASE')
)

with open('prompts.json') as f:
    prompts = json.load(f)

sys_prompt = prompts['sys-prompt']
sys_prompt += prompts['sdx-1']
# sys_prompt += prompts['sdx-2']

with open('schema.txt') as f:
    sys_prompt += f'\n\nThe schema is:\n{f.read()}'

with open('agent_tools.json') as f:
    agent_tools = json.load(f)

messages = [{'role': 'system', 'content': sys_prompt}]


def add_user_message(msg):
    messages.append({'role': 'user', 'content': msg})


def add_assistant_message(msg):
    messages.append({'role': 'assistant', 'content': msg})


def query_user(prompt):
    if not prompt.endswith('\n'):
        prompt += '\n'
    add_assistant_message(prompt)
    add_user_message(input(prompt))


def query():
    if verbose:
        print(f'query()')

    raw_output = client.chat.completions.create(
            messages=messages,
            model='gpt-4o-mini',
            tools=agent_tools
    )
    finish_reason = raw_output.choices[0].finish_reason
    if finish_reason == 'tool_calls':
        for tool_call in raw_output.choices[0].message.tool_calls:
            execute_func(tool_call.function)
    elif finish_reason == 'stop':
        query_user(raw_output.choices[0].message.content)
    else:
        print(f'Bad finish reason: {finish_reason}. Output:')
        print(raw_output)
        raise ValueError('Bad finish reason')


def execute_func(func: Function):
    name = func.name
    args = json.loads(func.arguments)
    if verbose:
        print(f'execute_func(): {name}({args})')

    if name == 'query_database':
        query_database(args['sql_string'])

    elif name == 'modify_database':
        modify_database(args['sql_string'])

    elif name == 'send_message_to_user':
        msg = args['message']
        if msg != messages[-1]['content']:
            add_assistant_message(msg)
            print(msg)

    elif name == 'ask_user_a_question':
        msg = args['message']
        if msg != messages[-1]['content']:
            query_user(msg)

    elif name == 'wait_for_user_response':
        if messages[-1]['role'] != 'user':
            add_user_message(input(''))
        else:
            query()

    else:
        raise ValueError(f'Unrecognized function call: {name}')


def query_database(sql_string):
    print(f'Executing SQL: {sql_string}')
    add_user_message(f'[DB-PROGRAM]: Executing SQL query: {sql_string}')
    cursor = mydb.cursor()
    try:
        cursor.execute(sql_string)
        add_user_message(f'[DB-PROGRAM]: SQL results: {str(cursor.fetchall())}')
    except Exception as e:
        print(e)
        print(str(e))
        add_user_message(f'[DB-PROGRAM]: Query failed. Error: {e}')


def modify_database(sql_string):
    print(f'Executing SQL: {sql_string}')
    add_user_message(f'[DB-PROGRAM]: Executing SQL command: {sql_string}')
    cursor = mydb.cursor()
    try:
        cursor.execute(sql_string)
        add_user_message(f'[DB-PROGRAM]: Finished executing.')
    except Exception as e:
        add_user_message(f'[DB-PROGRAM]: Execution failed. Error: {e}')


def main():
    while True:
        query()


if __name__ == "__main__":
    main()
