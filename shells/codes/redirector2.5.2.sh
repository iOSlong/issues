#以< 改变标准输入

tr -d '\r' < dos-file.txt

#以 > 改变标准输出

tr -d '\r' < dos-file.txt > UNIX-file.txt

#以 >> 附加到文件

for f in dos-file.txt
do
 tr -d '\r' < $f >> big-UNIX-file.txt
done


