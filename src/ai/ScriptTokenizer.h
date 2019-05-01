#pragma once



#undef YY_DECL
#define YY_DECL ai::ScriptParser::symbol_type ai::ScriptTokenizer::yylex()

#include <iostream>

#ifndef yyFlexLexerOnce
#include <FlexLexer.h>
#endif

#include <parser.tab.hh>
#include "location.hh"

namespace ai {

    // forward declare to avoid an include
    class ScriptLoader;

    class ScriptTokenizer : public yyFlexLexer {
    public:
        ScriptTokenizer(ai::ScriptLoader &driver) : yyFlexLexer(std::cin, std::cout), _driver(driver) {}
        virtual ~ScriptTokenizer() {}
        virtual ai::ScriptParser::symbol_type yylex(ai::ScriptLoader &driver);
    private:
        ai::ScriptLoader &_driver;
    };
}
