#!/usr/bin

myvar=this_is_a_long_string_that_does_not_mean_much
echo $myvar

#单行可以进行多次赋值
first=isaac middle=bashevis last=singer
#值中包含空格时使用引号
fullname="isaac bashevis singer"
#变量间赋值不需要引号
oldname=$fullname

desc1="先写变量名称，紧接着= 字符，最后是新值，中间完全没有任何空格"
desc2="当你取变量值时候前面需要$符号，值中有空格的时候需要添加引号"

echo $first 
echo $oldname
echo $desc1
echo $desc2

echo $first
echo first middle last
echo "较为复杂的输出，可以使用printf"

