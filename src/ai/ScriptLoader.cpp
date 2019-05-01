#include "ScriptLoader.h"

#include "ScriptTokenizer.h"
#include "grammar.gen.tab.hh"


int ai::ScriptLoader::parse(std::istream& in, std::ostream& out) {

    ai::ScriptTokenizer scanner {*this};
    ai::ScriptParser parser {*this, scanner};

    int res = parser.parse();

    return res;
}
