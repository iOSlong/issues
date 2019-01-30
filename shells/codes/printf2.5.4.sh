#!/usr/bin

var_desc1="printf不想echo 那样会自动提供一个换行符号，你必须显示地将换行符指定为'\n'写出来"
var_desc2="语法：'printf format-string\{arguments …\}\n"

echo $var_desc1

printf $var_desc2

printf "\n The first program always prints '%s,%s!'\n" Hello world 
