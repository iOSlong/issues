#!/bin/sh

##### several cases that the scripts does not work:
##### 1) there is space or slash in the resources file, such as "aaa .png" 资源文件名中含有空格或者/
##### 2) reference resources in commented code 资源引用代码被注释了
##### 3) you need to manually checked the resources one by one in the result 对于脚本检查结果，最好人工检查一遍
##### 4) you can add some other types more than png, jpg, gif, wav, m4a 如果需要检查其他资源，请自行修改脚本；
##### 5)默认文件后缀都是如@2x.png格式，如果后缀格式不同，请自行修改脚本；


#### set parameters：PrjPath为项目工程所在目录，包含.m .xib文件；ResPath为被扫描的资源文件目录，包含.png .wav
#### xcodeprojPath为工程xcodeproj位置
PrjPath=/Users/lxw/Desktop/ntc/repositories/ysdq/Le123PhoneClient
ResPath=/Users/lxw/Desktop/ntc/repositories/ysdq/Le123PhoneClient
xcodeprojPath=/Users/lxw/Desktop/ntc/repositories/ysdq/Le123PhoneClient.xcodeproj


if [ -f ~/Desktop/resource_san_result.txt ];then
rm -f ~/Desktop/resource_san_result.txt
fi


cd $PrjPath
files=$(find . -name "*.m" -o -name "*.xib" -o -name "*.mm" -o -name "*.plist")

cd $ResPath
for png in $(find . -name "*.png" -o -name "*.jpg" -o -name "*.gif" -o -name "*.wav" -o -name "*.m4a")
do

basename='basename/'$png
basename=${basename##*/}
# echo $basename

if [ "${basename##*.}" == "png" ];then

echo $basename|grep -q @2x.png

if [ $? -eq 0 ];then
name=${basename%%@2x.png}
else
echo $basename|grep -q @3x.png
if [ $? -eq 0 ];then
name=${basename%%@3x.png}
else
name=${basename%.png}
fi
fi

elif [ "${basename##*.}" == "jpg" ];then
echo $basename|grep -q @2x.jpg
if [ $? -eq 0 ];then
name=${basename%%@2x.jpg}
else
echo $basename|grep -q @3x.jpg
if [ $? -eq 0 ];then
name=${basename%%@3x.jpg}
else
name=${basename%%.jpg}
fi
fi

elif [ "${basename##*.}" == "gif" ];then
echo $basename|grep -q @2x.gif
if [ $? -eq 0 ];then
name=${basename%%@2x.gif}
else
echo $basename|grep -q @3x.gif
if [ $? -eq 0 ];then
name=${basename%%@3x.gif}
else
name=${basename%%.gif}
fi
fi

elif [ "${basename##*.}" == "wav" ];then
name=${basename%%.wav}

elif [ "${basename##*.}" == "m4a" ]; then
name=${basename%%.m4a}

else
name=''
fi


if [ ${#name} -gt 0 ];then
# # name=${name%%[0-9]*}

cd $PrjPath
if grep -q $name $files;then
echo "$png" is used

else
cd $xcodeprojPath
if grep -q $name project.pbxproj;then
echo "$png" is not used >> ~/Desktop/resource_san_result.txt
else
echo "$png" is not packaged
fi
fi
else
echo name is empty
fi

done


if [ -f ~/Desktop/resource_san_result.txt ]; then
echo ***************the end of scan. Please see result from resource_san_result.txt
else
echo ***************the end of scan, everything is OK
fi


