#!/bin/sh
set -eu
readonly MODEL_ID=anthropic.claude-3-haiku-20240307-v1:0
readonly AWS_REGION=ap-northeast-1

execute(){
  cat <<EOF >test.json
{
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "あなたはテクニカルサポートエンジニアです。\n以下の <inquiry> と </inquiry> タグに囲まれた部分に記載する問い合わせ内容が、5W2H(What, Who, Where, When, Why,How,How much)の観点が適切に含まれているか判断し、また、AWS 公式のガイドライン「https://aws.amazon.com/jp/premiumsupport/tech-support-guidelines/」と照らし合わせた場合に適切な問い合わせ内容となっているかの判断をしてください。\nもし適切でない場合、より良いサポート体験を得られるための適切な問い合わせ文面を考えてください。\nその際には、<example> から </example> タグに記載の書式を参考としてください。\nまた参考の書式内では、より良い問い合わせ文面として適切と思われる内容を例示しつつ、お客様任意で書き換えを想定する箇所は'{}'で括って示してください。\n\n・評価対象の文書\n<inquiry>\n${text}\n</inquiry>\n\n・改善する場合の問い合わせ書式\n<example>\n{問い合わせ内容の概要を記載する}についておしえてください。 \n\n[実行環境(リソースID等含む)]\n{問い合わせ時に有用なリソースを特定するための一意な情報を記載する}\n\n[現在の状況(頻度も)]\n{問い合わせ内容の事象の発生状況や頻度を記載する}\n\n[既に調査したこと(手順、実行日時、ログの抜粋等)]\n{問い合わせを行う前に検証した内容があればそれを記載する}\n\n[推察、気になっていること]\n{ログや証跡などから考えらえる推論があれば記載する}\n\n[最終的に実現したいこと]\n{この問い合わせで実現したいことを記載する}\n\n[経緯、背景、緊急度が高い理由]\n{問い合わせに至った背景や事象の説明を記載する}\n</example>"
        }
      ]
	}
  ],
  "anthropic_version": "bedrock-2023-05-31",
  "max_tokens": 4096,
  "temperature": 1,
  "top_k": 250,
  "top_p": 0.999,
  "stop_sequences": [
    "\\n\\nHuman:"
  ]
}
EOF

  aws bedrock-runtime invoke-model \
    --model-id "${MODEL_ID}" \
    --body file://test.json \
    --cli-binary-format raw-in-base64-out \
    --region "${AWS_REGION}" \
    invoke-model-output.txt

  jq -r '.content[].text' <invoke-model-output.txt
  rm -rf test.json invoke-model-output.txt
  exit 0
}

usage() {
  cat <<_EOT_

Usage:
  ./$(basename ${0}) [command] [<options>]

Description:
  シェルスクリプトの引数に渡された文字列を
  AWS テクニカルサポートのガイドラインに照らし合わせて
  適切な問い合わせ文面となっているかのチェックをします。

Options:
  -v  print $(basename ${0}) version
  -h  print this
  -e  Check the <options> string by Amazon Bedrock.

_EOT_
  exit 1
}

version() {
  echo "$(basename ${0}) version 0.0.1"
  exit 1
}  

while getopts :hve opt
do
  case $opt in
    h)
      usage
    ;;
    v)
      version
    ;;
    e)
      text=${2}
      execute
    ;;
    *)
      echo "[ERROR] Invalid option '${1}'"
      usage
      exit 1
    ;;
  esac      
done