#!/bin/bash

mkdir -p gen
rm -f gen/rules
rm -f gen/tokens.flex
rm -f gen/tokens.y
rm -f gen/enums.h

echo "#pragma once" >> gen/enums.h


ALL_TYPES="fact "
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

    #TYPETOKEN=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$NAME")
    #echo "%token ${TYPETOKEN}" >> gen/tokens.y

    # Can't be arsed to do this properly
    if [[ "$TYPE" = "Age" ]]; then
        RULEMATCHES+="| BuildingCastle \n"
    fi

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

    TYPELOWERCASE=$(tr '[:upper:]' '[:lower:]' <<<"$TYPE")
    if [[ -z "${ALL_TYPES}" ]]; then
        ALL_TYPES+="    ${TYPELOWERCASE}"
    else
        ALL_TYPES+="  | ${TYPELOWERCASE}"
    fi
done < lists/parameters.list

printf "\nsymbolname:\n${ALL_TYPES}\n" >> gen/rules

printf "enum class ParameterType {\n${LVAL_ENUMS}\n};" >> gen/enums.h

LVAL_ENUMS=""
ALL_ACTIONS=""
LAST_ACTION=""
while read -r -a LINE; do
    ACTION="${LINE[0]}"
    STRING="${ACTION}"
    ACTION=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"${ACTION}")

    ACTIONLOWERCASE=$(tr '[:upper:]' '[:lower:]' <<<"$ACTION")
    LINE=("${LINE[@]:1}")
    #RULEMATCHES=""
    if [[ "${LAST_ACTION}" = "${ACTION}" ]]; then
        RULEMATCHES="    |  ${ACTION}"
    else
        RULEMATCHES="${ACTIONLOWERCASE}:\n    ${ACTION}"
    fi
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
        TOKENNAME=$(tr '[:upper:]' '[:lower:]' <<<"$NAME")
        if [[ "${TOKENNAME}" = "string" ]]; then
            TOKENNAME="String"
        fi
        if [[ "${TOKENNAME}" = "number" ]]; then
            TOKENNAME="Number"
        fi

        RULEMATCHES+=" ${TOKENNAME}"
    done


    if [[ "$ACTION" != "$LAST_ACTION" ]]; then
        echo "\"${STRING}\"    { RET_TOKEN(${ACTION}) }" >> gen/tokens.flex

        if [[ -z "${ALL_ACTIONS}" ]]; then
            ALL_ACTIONS+="    ${ACTIONLOWERCASE}"
        else
            ALL_ACTIONS+="  | ${ACTIONLOWERCASE}"
        fi
    fi

    LVAL_ENUMS+="    Action${ACTION},\n"
    echo "%token ${ACTION}" >> gen/tokens.y
    if [[ -n "${RULEMATCHES}" ]]; then
        printf "\n${RULEMATCHES}"  >> gen/rules
    fi

    LAST_ACTION="${ACTION}"
done < lists/actions.list

printf "\n"  >> gen/rules

printf "\naction:\n${ALL_ACTIONS}\n" >> gen/rules

printf "enum class ActionType {\n${LVAL_ENUMS}\n};" >> gen/enums.h

LVAL_ENUMS=""
ALL_FACTS=""
LAST_FACT=""
while read -r -a LINE; do
    FACT="${LINE[0]}"
    STRING="${FACT}"
    FACT=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"${FACT}")

    FACTLOWERCASE=$(tr '[:upper:]' '[:lower:]' <<<"$FACT")
    LINE=("${LINE[@]:1}")
    #RULEMATCHES=""

    if [[ "$FACT" = "$LAST_FACT" ]]; then
        RULEMATCHES="| ${FACT}"
    else
        RULEMATCHES="${FACTLOWERCASE}:\n    ${FACT}"
    fi

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
        TOKENNAME=$(tr '[:upper:]' '[:lower:]' <<<"$NAME")
        if [[ "${TOKENNAME}" = "string" ]]; then
            TOKENNAME="String"
        fi
        if [[ "${TOKENNAME}" = "number" ]]; then
            TOKENNAME="Number"
        fi


        RULEMATCHES+=" ${TOKENNAME}"
    done

    if [[ "$FACT" != "$LAST_FACT" ]]; then
        echo "\"${STRING}\"    { RET_TOKEN(${FACT}) }" >> gen/tokens.flex

        if [[ -z "${ALL_FACTS}" ]]; then
            ALL_FACTS+="    ${FACTLOWERCASE}"
        else
            ALL_FACTS+="  | ${FACTLOWERCASE}"
        fi
    fi

    LVAL_ENUMS+="    Fact${FACT},\n"
    echo "%token ${FACT}" >> gen/tokens.y
    if [[ -n "${RULEMATCHES}" ]]; then
        printf "\n${RULEMATCHES}\n"  >> gen/rules
    fi
    LAST_FACT="${FACT}"
done < lists/facts.list

printf "\nfact:\n${ALL_FACTS}\n" >> gen/rules

printf "enum class Fact {\n${LVAL_ENUMS}\n};" >> gen/enums.h

rm -f grammar.gen.y && cat parser.head.y <(sort -u < gen/tokens.y) parser.mid.y gen/rules  parser.tail.y > grammar.gen.y
rm -f tokenizer.gen.flex && cat tokenizer.head.flex gen/tokens.flex tokenizer.tail.flex > tokenizer.gen.flex

flex++ -Ca  -+  tokenizer.gen.flex  && bison --language=C++  --defines --debug -v -d grammar.gen.y
