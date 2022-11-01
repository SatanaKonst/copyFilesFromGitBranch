#!/bin/bash

#Папка куда копировать файлы
COPY_DIR_PATH="$(pwd)/dirForCopyFiles"

#Коммит с которого начинать копирование (Не участвует в работе т.е. копирование начинается со следующего)
START_COMMIT="1b313534";

mkdir -p $COPY_DIR_PATH

#Получаем список коммитов и разворачиваем их
COMMITS=$(git log --pretty=format:"%h" $START_COMMIT...HEAD)
COMMITS=(`echo ${COMMITS}`);

#Несемся по массиву (волосы развиваются на ветру, язык высунув :) ) и копируем файлы. 
#Если файлы были удалены, то будут сообщения, что файл не найден. 
#Нет никаких игнорировний. Тупо в лоб получаем состояние репозитория

for i in $(seq $((${#COMMITS[@]} - 1)) 0); do
    CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r ${COMMITS[$i]})
    for file in $CHANGED_FILES;
    do
        FILE_DIR="$(dirname -- $file)"
        mkdir -p "${COPY_DIR_PATH}/${FILE_DIR}"
        cp $file "${COPY_DIR_PATH}/${file}"
    done
done