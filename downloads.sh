#!/bin/bash
#设置命令行参数，无输入则为默认
page_num1=$1
page_num2=$2
if [ -z $1 ];then
    page_num1=1
fi
if [ -z $2 ];then
    page_num2=126
fi

for i in `seq $page_num1 $page_num2`
do

echo "processing url $i now"

#使用curl命令以及grep指令和正则表达式提取图片信息并重定向输出至文本
curl https://bing.ioliu.cn/?p=$i | grep -Eo '<img[^>]*src="[^"]*[^"]*"[^>]*>'  | grep -Eo 'src="[^"]*"' | sed 's/src="//g' | sed 's/"//g' >> image.txt
#同理，将名称信息输出至z1.txt
curl https://bing.ioliu.cn/?p=$i | grep -Eo '<h3>(.|\n)*?</h3>' | sed 's/<[^>]*>/ /g' | sed 's/(/ /g' | sed 's/)/ /g' | sed 's/?/ /g' | sed 's/\// /g' | sed 's/分享/\n/g' | sed 's/[0-9a-zA-Z]*/ /g' | sed 's/- -/ /g' | sed 's/+//g' | sed 's/\ //g' >> z1.txt
#将日期信息重定向输出至z2.txt
curl https://bing.ioliu.cn/?p=$i | grep -o '20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]' >> z2.txt

done
#设置图片输出路径
path="bingdownload"
if [ ! -d "./$path" ]; then
  mkdir "./$path"
fi
#利用循环在记录中找到对应的名称并使用字符串拼接重命名
a=0
for line in `cat z1.txt`
do
  name=$line
  names[$a]=$name  
  let a++
done

b=0
for line in `cat z2.txt`
do
  time=$line
  times[$b]=$time  
  let b++
done


i=0;
#使用curl指令下载得到图片并进行重命名
for url in `sort image.txt | uniq`
do
    i=`expr $i + 1`
    echo "downloading picture $i"
    curl -o ./$path/${times[$i]}" "${names[$i]} $url 
done
