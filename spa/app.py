from flask import Flask, render_template, request, jsonify
import boto3
import json

app = Flask(__name__)

# AWS Bedrock クライアントの設定
bedrock_runtime = boto3.client(
    service_name='bedrock-runtime',
    region_name='ap-northeast-1'
)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate():
    user_input = request.form['user_input']
    
    # 定型文と入力を組み合わせる
    prompt = f"あなたはテクニカルサポートエンジニアです。\n以下の <inquery> と </inquery> タグに囲まれた部分に記載する問い合わせ内容が、5W2H（What, Who, Where, When, Why,How,How much”の観点が適切に含まれているか判断し、また、AWS 公式のガイドライン「https://aws.amazon.com/jp/premiumsupport/tech-support-guidelines/」と照らし合わせた場合に適切な問い合わせ内容となっているかの判断をしてください。\nもし適切でない場合、より良いサポート体験を得られるための適切な問い合わせ文面を考えてください。\nその際には、<example> から </example> タグに記載の書式を参考としてください。\nまた参考の書式内では、より良い問い合わせ文面として適切と思われる内容を例示しつつ、お客様任意で書き換えを想定する箇所は（）で括って示してください。\n\n・評価対象の文書\n<inquery>\n{user_input}\n</inquery>\n\n・改善する場合の問い合わせ書式\n<example>\n（問い合わせ内容の概要を記載する）についておしえてください。 <br><br>[実行環境(リソースID等含む)]<br>（問い合わせ時に有用なリソースを特定するための一意な情報を記載する）<br><br>[現在の状況(頻度も)]<br>（問い合わせ内容の事象の発生状況や頻度を記載する）<br><br>[既に調査したこと(手順、実行日時、ログの抜粋等)]<br>（問い合わせを行う前に検証した内容があればそれを記載する）<br><br>[推察、気になっていること]<br>（ログや証跡などから考えらえる推論があれば記載する）<br><br>[最終的に実現したいこと]<br>（この問い合わせで実現したいことを記載する）<br><br>[経緯、背景、緊急度が高い理由]<br>（問い合わせに至った背景や事象の説明を記載する）\n</example>"

    # Bedrock モデルの呼び出し
    response = bedrock_runtime.invoke_model(
        modelId='anthropic.claude-3-haiku-20240307-v1:0',
        contentType='application/json',
        accept='application/json',
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 4096,
            "messages": [
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        })
    )

    # レスポンスの解析
    response_body = json.loads(response['body'].read())
    generated_text = response_body['content'][0]['text']
    return jsonify({'response': generated_text})

if __name__ == '__main__':
    app.run(debug=True)

