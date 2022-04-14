#! /usr/bin/env bash


function Help() {
    echo "-q Q               对JPEG格式图片进行质量压缩 质量因子为Q"
    echo "-r R               对JPEG/PNG/SVG格式图片在保持原始宽高比的前提下压缩分辨率 R"
    echo "-w font_size text  对图片批量添加自定义文本水印"
    echo "-p text            批量重命名 统一添加文件名前缀 不影响原始文件扩展名"
    echo "-s text            批量重命名 统一添加文件名后缀 不影响原始文件扩展名"
    echo "-t                 将PNG/SVG图片统一转换为JPG格式"
    echo "-h                 帮助文档"
}

#对JPEG格式图片进行质量压缩
function QualityCompress {
     Q=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} == "jpg" || ${type} == "jpeg" || ${type} == "JPEG" ]];then
            convert "${i}" -quality "${Q}" "${i}"
            echo "${i} QualityCompress"
        fi
    done
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function CompressionResolution {
    R=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} == "jpg" || ${type} == "png" || ${type} == "svg" || ${type} == "jpeg" || ${type} == "JPEG" ]];then
            convert "${i}" -resize "${R}" "${i}"
            echo "${i} CompressionResolution success"
        fi
    done
}

#图片批量添加文本水印
function AddWatermark {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "png" && ${type} != "svg" && ${type} != "jpeg" && ${type} != "JPEG" ]];then continue;fi;
        convert "${i}" -pointsize "$1" -fill pink -gravity center -draw "text 5,5 '$2'" "${i}"
        echo "${i} 文本水印 $2 已添加完成"
    done
}

#统一添加文件名前缀，不影响原始文件扩展名
function AddPrefix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "png" && ${type} != "svg" && ${type} != "jpeg" && ${type} != "JPEG" ]]; then continue; fi;
        mv "${i}" "$1""${i}"
        echo " ${i} 添加了前缀 $1${i} "
    done
}

#统一添加文件名后缀，不影响原始文件扩展名
function AddSuffix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpg" && ${type} != "png" && ${type} != "svg" && ${type} != "jpeg" && ${type} != "JPEG" ]]; then continue; fi;
        newname=${i%.*}$1"."${type} #${i%.*}将文件名"."左侧保留
        mv "${i}" "${newname}"
        echo " ${i} 添加了文件名后缀 ${newname} "
    done
}

#将png/svg图片统一转换为jpg格式图片
function ImageTojpg {
    for i in *;do
        type=${i##*.}
        if [[ ${type} == "png" || ${type} == "svg" ]]; then
            newname=${i%.*}".jpg"
            convert "${i}" "${newname}"
   	        echo " ${i} has been transformed into  ${newname} "
        fi
    done
}

#main
while [ "$1" != "" ];do
    case "$1" in
        "-q")
            QualityCompress "$2"
            exit 0
            ;;
        "-r")
            CompressionResolution "$2"
            exit 0
            ;;
        "-w")
            AddWatermark "$2" "$3"
            exit 0
            ;;
        "-p")
            AddPrefix "$2"
            exit 0
            ;;
        "-s")
            AddSuffix "$2"
            exit 0
            ;;
        "-t")
            ImageTojpg
            exit 0
            ;;
        "-h")
            Help
            exit 0
            ;;
    esac
done
