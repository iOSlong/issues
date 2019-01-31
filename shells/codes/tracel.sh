#! /bin/sh

set -x         #打开跟踪功能
echo 1st echo

set +x         #关闭跟踪功能
echo 2nd echo

# chmod +x tracel.sh  设置执行权限
# ./tracel.sh         执行  查看效果
