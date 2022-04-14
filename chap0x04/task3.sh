#!/usr/bin/env bash

function Help {
    echo "-c      统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-i      统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-u      统计最频繁被访问的URL TOP 100"
    echo "-p      统计不同响应状态码的出现次数和对应百分比"
    echo "-a      分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-s URL  给定URL输出TOP 100访问来源主机"
    echo "-h      帮助文档"
}
# 统计访问来源主机TOP 100和分别对应出现的总次数
function TOP_100 {
    printf "%30s\t%s\n" "TOP100_host" "count"
    awk -F "\t" '#定义\t作为分隔符
    NR>1 {host[$1]++;}#NR 是总共读取了多少行
    END { for(i in host) {printf("%30s\t%d\n",i,host[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计访问来源主机TOP 100 IP和分别对应出现的总次数
function TOPIP_100 {
    printf "%20s\t%s\n" "TOP100_IP" "count"
    awk -F "\t" '
    NR>1 {if(match($1, /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/)) ip[$1]++;}#表示$1与“/ /”里面的正则表达式进行匹配，若匹配，则ip[$1]++
    END { for(i in ip) {printf("%20s\t%d\n",i,ip[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计最频繁被访问的URL TOP 100
function TOPURL_100 {
    printf "%60s\t%s\n" "TOP100_URL" "count"
    awk -F "\t" '
    NR>1 {url[$5]++;}#url是第五列
    END { for(i in url) {printf("%60s\t%d\n",i,url[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计不同响应状态码的出现次数和对应百分比
function StateCode {
    awk -F "\t" '
    BEGIN {printf("code\tcount\tpercentage\n");}
    NR>1 {code[$6]++;}#记录每种状态码出现次数
    END { for(i in code) {printf("%d\t%d\t%f%%\n",i,code[i],100.0*code[i]/(NR-1));} }
    ' web_log.tsv
}

# 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数，有404、403两种
function StateCode4XX {
    printf "%60s\t%s\n" "code=403 URL" "count"
    awk -F "\t" '
    NR>1 { if($6=="403") code[$5]++;} #第六列是状态码，如果等于403，则该行的第五列即url统计次数加一
    END { for(i in code) {printf("%55s\t%d\n",i,code[i]);} }' web_log.tsv | sort -g -k 2 -r | head -10 #列出经过筛选的列表的前十

    printf "%60s\t%s\n" "code=404 URL" "count"
    awk -F "\t" '
    NR>1 { if($6=="404") code[$5]++;}  #第六列是状态码，如果等于404，则该行的第五列即url统计次数加一
    END { for(i in code) {printf("%55s\t%d\n",i,code[i]);;} }' web_log.tsv | sort -g -k 2 -r | head -10 #列出经过筛选的列表的前十
}

# 给定URL输出TOP 100访问来源主机
function URL_Top100 {
    printf "%40s\t%s\n" "TOP100_host" "count"
    awk -F "\t" '
    NR>1 {if("'"$1"'"==$5) {host[$1]++;} } #输入某个url与tsv文件中的第五列中有的url进行匹配，匹配到之后对应url统计次数加一
    END { for(i in host) {printf("%40s\t%d\n",i,host[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 主程序
while [ "$1" != "" ];do
    case "$1" in
       "-c")
      TOP_100
      exit 0
      ;;
       "-i")
      TOPIP_100
      exit 0
      ;;
       "-u")
      TOPURL_100
      exit 0
      ;;
       "-p")
      StateCode
      exit 0
      ;; 
       "-a")
      StateCode4XX
      exit 0
      ;;
       "-s")
      URL_Top100 "$2"
      exit 0
      ;;
       "-h")
      Help
      exit 0
      ;;
    esac
done
