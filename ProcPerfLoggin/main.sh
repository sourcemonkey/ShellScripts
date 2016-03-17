#!/bin/bash

# 日付・時刻情報の設定
DATE=`date +"%Y%m%d"`
TIME=`date +"%H:%M:%S"`

# ログ出力先のディレクトリ
OUTPUT_DIR='/tmp/ProcPerfLoggin'

usage() {
  echo "Usage: $0 pid"
}

# 引数の判定
case $# in
  1)
    PID=$1
    ;;
  *)
    usage
    exit
esac

# 対象PIDのps情報を設定
LINE="${TIME} "`ps aux | awk '{ if($2 == '${PID}') print }'`
# echo `ps aux | gawk '{ if($2 == '${PID}') print}'`
# echo `ps aux | grep ruby`
# echo `ps aux | grep ruby | awk '{print $2}'`

# 対象PIDのps情報が無ければ終了
[ -z "${LINE}" ] && exit

#ファイル名の設定
FILENAME="pid_${PID}.${DATE}.log"

# ps情報の出力
echo ${LINE} >> "${OUTPUT_DIR}/${FILENAME}"
