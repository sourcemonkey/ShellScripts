#!/bin/bash

# デバッグ用
while getopts dlh: OPT
do
  case $OPT in
    d)
      set -x
      ;;
  esac
done

# Archiveディレクトリ設定
archive_base_dir='/Users/fumiaki.sato/tmp/TestProject/ShellScripts/ArchiveRelocate/main.sh'

# 作業ディレクトリの移動
cd ${archive_base_dir}

## 保険者番号管理ファイル処理
hokenja_dest_dir="${archive_base_dir}/hokensha_num_mng/" # 保険者番号管理ファイル移動先ディレクトリ
hokenja_pattern="HOKENJA_NUM_MNG-*"                      # 保険者番号管理ファイルの検索パターン

# 保険者番号管理ファイルの一覧作成
hokenja_files=`find . -maxdepth 1 -name "${hokenja_pattern}" -print`
# 保険者番号管理ファイルの移動先ディレクトリが無ければ作成
[ -e ${hokenja_dest_dir} ] || mkdir ${hokenja_dest_dir}
# 保険者番号管理ファイルの移動
[ -n "${hokenja_files}" ] && mv ${hokenja_files} ${hokenja_dest_dir}

# 作業対象の組合コード配列定義
kumiai_c_array=(
  '168'
  '182'
  '184'
  '218'
  '257'
  '269'
  '275'
  '292'
  '343'
  '369'
  '370'
  '372'
  '399'
  '405'
  '416'
  '426'
  '448'
  '478'
  '515'
  'AC1'
  'CA001'
  'FC001'
  'JP001'
  'JP002'
  'JP003'
  'JP004'
  'JP005'
  'NS001'
  'TX001'
  'UB001'
  'UB002'
  'UB003'
  'UB004'
  'UB005'
  'ZZ001'
  'ZZ002'
  'ZZ003'
  'ZZ004'
)

## 組合コード単位処理
for kumiai_c in ${kumiai_c_array[@]}; do
  dest_dir="${archive_base_dir}/${kumiai_c}" # 移動先ディレクトリの設定
  teki_tai_pattern="${kumiai_c}-*"           # 適用情報・対象者情報履歴ファイルの検索パターン
  iryohi_pattern="H01-${kumiai_c}*"          # 医療費通知ファイルの検索パターン

  # 適用情報ファイル、対象者情報履歴ファイルの一覧作成
  teki_tai_files=`find . -maxdepth 1 -name "${teki_tai_pattern}" -print`
  # 医療費通知ファイルの一覧作成
  iryohi_files=`find . -maxdepth 1 -name "${iryohi_pattern}" -print`

  [ -e ${dest_dir} ] || mkdir ${dest_dir}                        # 移動先ディレクトリが無ければ作成
  [ -n "${teki_tai_files}" ] && mv ${teki_tai_files} ${dest_dir} # 適用情報・対象者情報履歴ファイルの移動
  [ -n "${iryohi_files}" ]   && mv ${iryohi_files} ${dest_dir}   # 医療費通知ファイルの移動
done
