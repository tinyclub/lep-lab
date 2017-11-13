#!/bin/bash
#
# launch.sh -- Launch lepd and lepv
#

LEP_DIR=$(cd $(dirname $0)/ && pwd)

LEPD_DIR=$LEP_DIR/lepd

LEPV_DIR=$LEP_DIR/lepv
LEPV_APP=$LEPV_DIR/app
LEPV_IDX=$LEPV_APP/templates/index.html

LEPD_ARCH=${LEPD_ARCH:-x86}
LEPV_IP=${LEPV_IP:-localhost}
LEPV_PORT=${LEPV_PORT:-8889}

LEPV_URL=http://$LEPV_IP:$LEPV_PORT

WEB_BROWSER=chromium-browser

if [ $LEPD_ARCH != 'x86' ]; then
  QEMU_USER=qemu-$LEPD_ARCH
fi

# perf
echo "LOG: installing perf for `uname -r`"
dpkg -l linux-tools-`uname -r` | grep -q ^ii
if [ $? -ne 0 ]; then
   number=`apt-cache search linux-tools-`uname -r` | wc -l`
   [ $number -ne 0 ] && sudo apt-get install linux-tools-`uname -r`
fi

# lepd in local host
echo "LOG: Killing lepd"
pkill lepd

echo "LOG: Compiling lepd"
cd $LEPD_DIR && make ARCH=$LEPD_ARCH

echo "LOG: Running lepd"
cd $LEPD_DIR && $QEMU_USER ./lepd

# lepv server

echo "LOG: Killing lepv server"
pkill python3

echo "LOG: Change lepv server to localhost"
sed -i -e 's/www.rmlink.cn/localhost/g' $LEPV_IDX

echo "LOG: Running lepv server"
cd $LEPV_APP/ && python3 ./run.py &

# lepv client

$WEB_BROWSER $LEPV_URL &
