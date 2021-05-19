##!/bin/sh
#cd ~/Workspace/azure/rn-neon-mei
#yarn config set network-timeout 30000 -g
#yarn install
#adb reverse tcp:8088: tcp:8888
#osascript -e 'tell application "Terminal"
#    set dir to do shell script "pwd"
#    do script "cd " &dir & "&& yarn start --port=8888"
#end tell'
#yarn devStaging
#yarn config set network-timeout 300 -g

ROOT_DIR=$(pwd)
PROJECT_DIR=~/Workspace/azure/rn-neon-mei/
RN_PORT=8888
MIN_TIMOUT=300
MAX_TIMEOUT=30000

OPTIONS=(
  "Limpar cache"
  "Rodar o projeto"
  "Rodar o metro bundle"
  "set yarn 300 ms"
  "set yarn 30000 ms"
  "Limpar porta AV"
  "Remover app STG"
  "Teste"
)

setAdbPort(){
  DEVICES=$(adb devices)
  adb devices | while read line ; do
    NUMBER=$(echo $line | tr -dc '0-9')
    length=${#NUMBER}
    if [ $length -gt 0 ];
    then adb -s"$NUMBER" reverse tcp:"$RN_PORT" tcp:"$RN_PORT" && echo "device $NUMBER port changed to $RN_PORT";
#    else echo ""
    fi
  done
}

clearApk(){
  cd "$PROJECT_DIR"
  pwd
  yarn config set network-timeout "$MAX_TIMEOUT" -g
  setAdbPort
  rm -rf node_modules && yarn cache clean && yarn && yarn run instrumentDynatrace && yarn start --port="$RN_PORT" --reset-cache
}

runStart(){
  clear
  cd "$PROJECT_DIR"
  pwd
  yarn start --port="$RN_PORT"
}

runApk(){
  clear
  cd "$PROJECT_DIR"
  pwd
  yarn config set network-timeout "$MAX_TIMEOUT" -g
  yarn install
#  adb reverse tcp:"$RN_PORT" tcp:"$RN_PORT"
  setAdbPort

  osascript -e 'tell application "Terminal"
      set dir to do shell script "pwd"
      do script "cd " &dir &  "&& yarn start --port=" & "'"$RN_PORT"'"
  end tell'
  yarn devStaging
  yarn config set network-timeout "$MIN_TIMOUT" -g
}

setYarnMs(){
  clear
  echo "vai setar para $1 ms"
  yarn config set network-timeout "$1" -g
}

testCommand(){
  echo "$RN_PORT"
#  osascript -e 'tell application "Terminal"
#      set dir to do shell script "pwd"
#      do script "echo " &dir &  " && echo " & "'"$RN_PORT"'"
#  end tell'
#  osascript -e 'display dialog "'"$RN_PORT"'"'

#-eq # Equal
#-ne # Not equal
#-lt # Less than
#-le # Less than or equal
#-gt # Greater than
#-ge # Greater than or equal

#  DEVICES=$(adb devices)
#  adb devices | while read line ; do
#    NUMBER=$(echo $line | tr -dc '0-9')
#    length=${#NUMBER}
#    if [ $length -gt 0 ];
#    then adb -s"$NUMBER" reverse tcp:"$RN_PORT" tcp:"$RN_PORT";
#    else echo ""
#    fi
#  done
}

clearAVPort(){
  echo "Vai limcar a porta do AV"
  cd "$ROOT_DIR"
  ./clearPort.sh
}

removeApk(){
  echo "Vai remover o apk"
  cd "$PROJECT_DIR"
  yarn app:removeSTG
}

echo "Menu RN"

PS3="$PROMPT "
select opt in "${OPTIONS[@]}" "Sair"; do
    case "$REPLY" in
    1) clearApk clearApk ; break;;
    2) runApk runApk ; break;;
    3) runStart runStart ; break;;
    4) setYarnMs "$MIN_TIMOUT" ; break;;
    5) setYarnMs "$MAX_TIMEOUT" ; break;;
    6) clearAVPort clearAVPort ; break;;
    7) removeApk removeApk ; break;;
    8) testCommand testCommand ; break;;
    $((${#OPTIONS[@]}+1))) echo "Vlw flw!"; break;;
    *) echo "Opcao invalida. Tente outro.";continue;;
    esac
done


