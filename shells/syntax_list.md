Syntax
### find file with dir
阅读文档说明：
> $ man find

#### Syntax

> find /dir/to/search -name "file-to-search"
find /dir/to/search -name "file-to-search" -print
find /dir/to/search -name "file-to-search" -ls
find /dir/to/search -name "regex" -print        


#### Examples - find command
##### find
* 查找当前目录下的文件,[suffix  .txt]
> $ find . -name '*.txt'

* 通过文件类型筛选，过滤掉不符合要求的掉特殊文件、管道、特殊符号等的查找方式
> $ find . -type f -name '*.pl'

* 在所有目录下进行文件型筛选查找
> $ find / -type f -name client.p12

    ```
    Generally this is a bad idea to look for files. 
    This can take a considerable amount of time. 
    It is recommended that you specify the directory name. 
    ```

* 在指定目录下进行查找
> $ find /usr/local -type f -name httpd.conf

* 用root 权限，进行全目录查找
> $ sudu find / -type f -name httpd.conf

* 寻找指定目录下，先前3天发生改动的.m 文件
> $ find /repositories/ -name '*.m' -mtime 3

##### grep
* 查找指定目录下 包含该字符串“hello world”的所有文件
    
    > $ grep -r "hello world" /repositories/



 







### 参考文档 
1. [UNIX Find A File Command](https://www.cyberciti.biz/faq/howto-find-a-file-under-unix/)
2. [Find Files in Linux, Using the Command Line](https://www.linode.com/docs/tools-reference/tools/find-files-in-linux-using-the-command-line/)
3. [How to Grep for Text in Files](https://www.linode.com/docs/tools-reference/tools/how-to-grep-for-text-in-files/)
4. [Regular-Expressions.info](https://www.regular-expressions.info/grep.html)
5. 


