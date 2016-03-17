#!/bin/bash

# ゲートウェイ設定
GATEWAY='gateway1'

# expectタイムアウト設定
EXPECT_TIMEOUT=10

# Host設定
HOSTS=(
  'knudev0001.svr.dev.kenko-pf.local'
  'knwdev0100.svr.dev.kenko-pf.local'
  'knwdev0101.svr.dev.kenko-pf.local'
  'knuqa0001.svr.qa.kenko-pf.local'
)

# User設定
USERS=(
  'knsys-amber'
  'knsys-beryl'
  'knsys-citrine'
  'knsys-dravite'
  'knsys-emerald'
  'knsys-fluorite'
)

UNKNOWN='unknown'

# 使用方法の出力
usage() {
  echo "Usage: $0 [-d] -l | hostname [username]"
}

# HOSTSに登録されているhost名(localhost）を検索し取得
get_hostname() {
  local fqdn=$1
  for host in ${HOSTS[@]}; do
    if [[ ${host} =~ ^${fqdn}$ ]]; then
      echo ${host%%.*}
      exit
    fi
  done
  echo ${UNKNOWN}
}

# HOSTSに登録されているhost名(FQDN)を検索し取得
get_fqdn() {
  local hostname=$1
  for host in ${HOSTS[@]}; do
    if [[ ${host} =~ ^${hostname}\..+$ ]]; then
      echo ${host}
      exit
    fi
  done
  echo ${UNKNOWN}
}

# USERSに登録されているuser名を検索し取得
exist_username() {
  local username=$1
  for user in ${USERS[@]}; do
    if [[ ${user} = ${username} ]]; then
      echo ${user}
      exit
    fi
  done
  echo ${UNKNOWN}
}

# HOSTSに登録されているhost名(localhost, FQDN)、user名を表示
list_display() {
  usage
  echo -e '\n\thostname:\t FQDN:'
  for host in ${HOSTS[@]}; do
    hostname=$(get_hostname ${host})
    echo -e "\t  ${hostname}\t   ${host}"
  done

  echo -e '\n\tusername:'
  for user in ${USERS[@]}; do
    echo -e "\t  ${user}"
  done

}

# 踏み台サーバを経由してSSHログイン
ssh_login() {
  # host名の
  fqdn=$(get_fqdn $1)
  [ ${fqdn} = ${UNKNOWN} ] && echo "Error: Unknown Hostname. ${1}" && exit 1

  user=$(exist_username $2)

  expect -c "
  exp_internal 0
  set user \"${user}\"
  set timeout ${EXPECT_TIMEOUT}
  spawn ssh ${GATEWAY}
  expect \"~]$ \"
  sleep 0
  if {\$user != \"unknown\" } {
    send \"ssh -o StrictHostKeyChecking=no -t ${fqdn} sudo su - ${user} \\n\"
  } else {
    send \"ssh -o StrictHostKeyChecking=no ${fqdn} \\n\"
  }
  expect \"~]$ \"
  interact
  "
}

# メイン処理
#   オプション処理
while getopts dlh: OPT
do
  case $OPT in
    d)
      set -x
      ;;
    l)
      list_display
      exit
      ;;
    \?)
      usage
      exit
  esac
done

shift $((OPTIND - 1))

#   引数処理
case $# in
  1|2)
    ssh_login $1 $2
    ;;
  *)
    usage
esac

exit
