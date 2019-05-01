#!/bin/bash

mkdir -p gen
rm -f gen/rules
rm -f gen/tokens.flex
rm -f gen/tokens.y
rm -f gen/enums.h

echo "#pragma once" >> gen/enums.h


LVAL_ENUMS=""
while read -r -a LINE; do

    TYPE="${LINE[0]}"
    TYPE="${TYPE#"<"}" # chop off <
    TYPE="${TYPE%">"}" # chop off > at the end
    TYPE=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$TYPE")

    LINE=("${LINE[@]:1}")
    RULEMATCHES=""
    ENUMS=""
    TOKENLIST=""
    for i in "${!LINE[@]}"; do
        TOKEN="${LINE[$i]}"

        if [[ "${TOKEN:0:1}" = "#" ]]; then
            break
        fi

        if [[ "${TOKEN}" = "%Number%" ]]; then
            if [[ "${i}" -lt 1 ]]; then
                RULEMATCHES+="    Number"
            else
                RULEMATCHES+="  | Number"
            fi
            continue
        fi
        RE='^[0-9].*?$'
        if [[ ! ${TOKEN} =~ $RE ]]; then
            TOKEN="${TYPEN}${TOKEN}"
        fi

        RE='^[a-zA-Z0-9-]+$'
        if [[ ! ${TOKEN} =~ $RE ]]; then
            continue
        fi
        NAME=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$TOKEN")
        TOKENNAME="${TYPE}${NAME}"

        echo "\"${TOKEN}\"    { RET_TOKEN(${TOKENNAME}) }" >> gen/tokens.flex

        #RULEMATCHES+=" ${TOKENNAME}"
        TOKENLIST+=" ${TOKENNAME}"
        if [[ "${i}" -lt 1 ]]; then
            RULEMATCHES+="    ${TOKENNAME}"
        else
            RULEMATCHES+="  | ${TOKENNAME}"
        fi
        RULEMATCHES+="  {}// static_cast<Condition*>(aiRule)->type = ${TYPE}::${NAME}; } \n"
        ENUMS+="    ${NAME},\n"
        LVAL_ENUMS+="    ${NAME},\n"
    done

    if [[ -n "${RULEMATCHES}" ]]; then
        printf "${TYPE}:" | tr '[:upper:]' '[:lower:]' >> gen/rules
        printf "\n${RULEMATCHES}\n" >> gen/rules
    fi

    if [[ -n "${TOKENLIST}" ]]; then
        echo "%token${TOKENLIST}" >> gen/tokens.y
    fi
    if [[ -n "${ENUMS}" ]]; then
        echo "enum class ${TYPE} {" >> gen/enums.h
        printf "${ENUMS}" >> gen/enums.h
        echo "};" >> gen/enums.h
    fi
done < lists/parameters.list

printf "enum class ParameterType {\n${LVAL_ENUMS}\n};" >> gen/enums.h

LVAL_ENUMS=""
ALL_ACTIONS=""
while read -r -a LINE; do
    echo "${LINE}"
    ACTION="${LINE[0]}"
    ACTION=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"${ACTION}")

    ACTIONLOWERCASE=$(tr '[:upper:]' '[:lower:]' <<<"$ACTION")
    LINE=("${LINE[@]:1}")
    #RULEMATCHES=""
    RULEMATCHES="${ACTIONLOWERCASE}:\n    ${ACTION}"
    ENUMS=""
    TOKENLIST=""
    for i in "${!LINE[@]}"; do
        TOKEN="${LINE[$i]}"

        if [[ "${TOKEN:0:1}" = "#" ]]; then
            break
        fi

        TOKEN="${TOKEN#"<"}" # chop off <
        TOKEN="${TOKEN%">"}" # chop off > at the end

        RE='^[a-zA-Z-]+$'
        if [[ ! ${TOKEN} =~ $RE ]]; then
            continue
        fi
        NAME=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$TOKEN")
        #TOKENNAME="${NAME}"
        TOKENNAME=$(tr '[:upper:]' '[:lower:]' <<<"$NAME")
        if [[ "${TOKENNAME}" = "string" ]]; then
            TOKENNAME="String"
        fi

        #echo "\"${TOKEN}\"    { RET_TOKEN(${TOKENNAME}) }" >> gen/tokens.flex
        echo "${ACTION} ${TOKEN}"

        #TOKENLIST+=" ${TOKENNAME}"
        RULEMATCHES+=" ${TOKENNAME}"
        #if [[ "${i}" -lt 1 ]]; then
        #    RULEMATCHES+="    ${ACTION} ${TOKENNAME}"
        #else
        #    RULEMATCHES+="  | ${ACTION} ${TOKENNAME}"
        #fi
        #RULEMATCHES+="  {}// static_cast<Condition*>(aiRule)->type = ${TYPE}::${NAME}; } \n"
        #ENUMS+="    ${NAME},\n"
        #LVAL_ENUMS+="    Action${NAME},\n"
    done

    if [[ -z "${ALL_ACTIONS}" ]]; then
        ALL_ACTIONS+="    ${ACTIONLOWERCASE}"
    else
        ALL_ACTIONS+="  | ${ACTIONLOWERCASE}"
    fi

    LVAL_ENUMS+="    Action${Action},\n"
    echo "%token ${ACTION}" >> gen/tokens.y
    if [[ -n "${RULEMATCHES}" ]]; then
        #printf "${ACTION}:" >> gen/rules
        #printf "${ACTION}:" | tr '[:upper:]' '[:lower:]' >> gen/rules
        printf "\n${RULEMATCHES}\n"  >> gen/rules
        #echo "%token${TOKENLIST}" >> gen/tokens.y
        #echo "enum class ${TYPE} {" >> gen/enums.h
        #printf "${ENUMS}" >> gen/enums.h
        #echo "};" >> gen/enums.h
    fi
done < lists/actions.list

printf "action:\n${ALL_ACTIONS}\n" >> gen/rules

printf "enum class ActionType {\n${LVAL_ENUMS}\n};" >> gen/enums.h

rm -f grammar.gen.y && cat parser.head.y gen/tokens.y parser.mid.y gen/rules  parser.tail.y > grammar.gen.y
rm -f tokenizer.gen.flex && cat tokenizer.head.flex gen/tokens.flex tokenizer.tail.flex > tokenizer.gen.flex

flex++ -Ca  -+  tokenizer.gen.flex  && bison --language=C++  --defines --debug -v -d grammar.gen.y
