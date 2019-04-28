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

        RE='^[a-zA-Z-]+$'
        if [[ ! ${TOKEN} =~ $RE ]]; then
            continue
        fi
        NAME=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$TOKEN")
        TOKENNAME="${TYPE}${NAME}"

        #echo "${TYPE}: ${NAME}= \"${TOKEN}\""
        #echo "\"${TOKEN}\"    { return yyTok; }" >> gen/tokens.flex
         echo "\"${TOKEN}\"    { return ${TOKENNAME}; }" >> gen/tokens.flex

        TOKENLIST+=" ${TOKENNAME}"
        if [[ "${i}" -lt 1 ]]; then
            RULEMATCHES+="    ${TOKENNAME}"
        else
            RULEMATCHES+="  | ${TOKENNAME}"
        fi
        RULEMATCHES+="  {}// static_cast<Condition*>(aiRule)->type = ${TYPE}::${NAME}; } \n"
        ENUMS+="    ${NAME},\n"
        LVAL_ENUMS+="    ${TYPE}${NAME},\n"
    done

    if [[ -n "${RULEMATCHES}" ]]; then
        #echo "${TYPE}:" >> gen/rules
        printf "${TYPE}:" | tr '[:upper:]' '[:lower:]' >> gen/rules
        printf "\n${RULEMATCHES}\n" >> gen/rules
        #echo "%token ${TYPE}" >> gen/tokens.y
        echo "%token${TOKENLIST}" >> gen/tokens.y
        echo "enum class ${TYPE} {" >> gen/enums.h
        printf "${ENUMS}" >> gen/enums.h
        echo "};" >> gen/enums.h
    fi
done < lists/parameters.list

printf "enum class ParameterType {\n${LVAL_ENUMS}\n};" >> gen/enums.h
# echo "%union {" >> gen/rules
# printf "	int number;\n	char *string;\n ParameterType type;\n}" >> gen/rules

rm -f grammar.gen.y && cat parser.head.y gen/tokens.y parser.mid.y gen/rules  parser.tail.y > grammar.gen.y
rm -f tokenizer.gen.flex && cat tokenizer.head.flex gen/tokens.flex tokenizer.tail.flex > tokenizer.gen.flex
