#!/bin/bash
#
# launch.sh -- Launch lepd and lepv
#

LEP_DIR=$(cd $(dirname $0)/ && pwd)

LEPD_DIR=$LEP_DIR/lepd

LEPV_DIR=$LEP_DIR/lepv
LEPV_APP=$LEPV_DIR/app
LEPV_IDX=$LEPV_APP/templates/index.html

ARCH=${ARCH:-x86}
IP=${IP:-localhost}
PORT=${PORT:-8889}

LEPV_URL=http://$IP:$PORT

PREBUILT=${PREBUILT:-0}
LEPD=$LEPD_DIR/lepd
[ $PREBUILT -eq 1 ] && LEPD=$LEPD_DIR/prebuilt-binaries/x86-lepd

WEB_BROWSER=chromium-browser

if [ $ARCH != 'x86' ]; then
  QEMU_USER=/usr/bin/qemu-$ARCH
fi

# perf
install_perf()
{
  local number

  dpkg -l linux-tools-`uname -r` | grep -q ^ii
  if [ $? -ne 0 ]; then
    echo "LOG: Installing perf for `uname -r`"
    apt-get -y update
    number=`apt-cache search linux-tools-`uname -r` | wc -l`
    [ $number -ne 0 ] && sudo apt-get install -y linux-tools-`uname -r`
  fi
}

# lepd in local host
build_lepd()
{
  echo "LOG: Compiling lepd"
  cd $LEPD_DIR
  make clean
  make -j4 ARCH=$ARCH
}

run_lepd()
{
  echo "LOG: Killing lepd"
  sudo pkill lepd

  if [ $PREBUILT -eq 0 ]; then
    build_lepd
    sync
  fi

  echo "LOG: Running lepd"
  sudo $QEMU_USER $LEPD
}

# lepv server

run_lepv_backend()
{
  echo "LOG: Killing lepv server"
  sudo pkill python3

  if [ -n "$SERVER" ]; then
    echo "LOG: Change lepd server to $SERVER"
    sed -i -e "s/www.rmlink.cn/$SERVER/g" $LEPV_IDX
  fi

  echo "LOG: Running lepv server"
  cd $LEPV_APP/ && python3 ./run.py &
}

# lepv client

run_lepv_frontend()
{
  $WEB_BROWSER $LEPV_URL >/dev/null 2>&1
}


# main

cmd=$1

case $cmd in
  perf)
    install_perf
    ;;
  build)
    build_lepd
    ;;
  lepd)
    run_lepd
    ;;
  lepv)
    run_lepv_backend
    ;;
  view)
    run_lepv_frontend
    ;;
  *)
    run_lepd &
    run_lepv_backend &
    run_lepv_frontend &
    ;;
esac
