#!/usr/bin/env bash

function Help {
    echo "-as                统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
    echo "-p                统计不同场上位置的球员数量、百分比"
    echo "-n                 名字最长的球员是谁？名字最短的球员是谁？"
    echo "-a                 年龄最大的球员是谁？年龄最小的球员是谁？"
    echo "-h                 帮助文档"
}

#统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
function AgeAnalysis {
	awk -F "\t" '
	BEGIN {age0_20=0;age20_30;age30_}
	$6!="Age" {
            if($6>=0&&$6<20) {age0_20++;}
            else if($6>=20&&$6<=30) {age20_30++;}
            else {age30_++;}
        }
	END {
            sum=age0_20+age20_30+age30_;
	    printf("年龄\t数量\t百分比\n");
            printf("<20\t%d\t%f%%\n",age0_20,age0_20*100.0/sum);
            printf("[20,30]\t%d\t%f%%\n",age20_30,age20_30*100.0/sum);
            printf(">30\t%d\t%f%%\n",age30_,age30_*100.0/sum);
         
        }' worldcupplayerinfo.tsv

}

#统计不同场上位置的球员数量、百分比
function Position {
	awk -F "\t" '
        BEGIN {sum=0}
        $5!="Position" {
            pos[$5]++;
            sum++;
        }#统计各个位置，球员总数量
        END {
            printf("    位置\t数量\t百分比\n");
            for(i in pos) {
                printf("%13s\t%d\t%f%%\n",i,pos[i],pos[i]*100.0/sum);
            }
        }' worldcupplayerinfo.tsv
}

# 名字最长的球员是谁，名字最短的球员是谁
function NameLength {
	awk -F "\t" '
        BEGIN {max=0; min=9999;}
        $9!="Player" {
            len=length($9);#将各球员名字长度算出
            names[$9]=len;#赋值长度给names数组
            max=len>max?len:max;#若len>max为真，则令max=len，否则max保持不变
            min=len<min?len:min;#若len<min为真，则令min=len，否则min保持不变
        }
        END {
            for(i in names) {#在names中遍历每一位球员
                if(names[i]==max) {
                    printf("名字最长的球员是%s.\n", i);
                } else  if(names[i]==min) {
                    printf("名字最短的球员是%s.\n", i);
                }
            }
        }' worldcupplayerinfo.tsv
}

function Age {
	awk -F "\t" '
	BEGIN {max=0; min=999;}
	$6!="Age" {
	age=$6;
	names[$9]=age;
	max=age>max?age:max;
        min=age<min?age:min;
        }
	END {
            
            for(i in names) {
                if(names[i]==max) { printf("年龄最大的球员是%s\n", i); }
            }
            
            for(i in names) {
                if(names[i]==min) { printf("年龄最小的球员是%s\n", i); }
            }
        }' worldcupplayerinfo.tsv
}

while [ "$1" != "" ];do
    case "$1" in
        "-as")
            AgeAnalysis
            exit 0
            ;;
        "-p")
            Position
            exit 0
            ;;
        "-n")
            NameLength
            exit 0
            ;;
        "-a")
            Age
            exit 0
            ;;
        "-h")
            Help
            exit 0
            ;;
    esac
done


