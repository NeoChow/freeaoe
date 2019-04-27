#include "AiScriptParser.h"

#include "core/Logger.h"

#include <tao/pegtl.hpp>
#include <tao/pegtl/analyze.hpp>
#include <tao/pegtl/contrib/raw_string.hpp>
#include <tao/pegtl/contrib/tracer.hpp>


namespace pegtl = tao::pegtl;


namespace AiGrammar
{
   // clang-format off
    struct S : pegtl::plus<pegtl::space>{};
    struct MS : pegtl::star<pegtl::space>{};

    struct RuleStart : TAO_PEGTL_ISTRING("defrule"){};
    struct ConditionActionSeparator : TAO_PEGTL_ISTRING("=>"){};
    struct Not : TAO_PEGTL_ISTRING("not"){};
    struct Or : TAO_PEGTL_ISTRING("or"){};

    struct LessThanShort : TAO_PEGTL_ISTRING("<"){};
    struct LessThanLong : TAO_PEGTL_ISTRING("less-than"){};
    struct LessThan : pegtl::sor<LessThanShort, LessThanLong>{};

    struct LessOrEqualShort : TAO_PEGTL_ISTRING("<="){};
    struct LessOrEqualLong : TAO_PEGTL_ISTRING("less-or-equal"){};
    struct LessOrEqual : pegtl::sor<LessOrEqualShort, LessOrEqualLong>{};

    struct GreaterThanShort : TAO_PEGTL_ISTRING(">"){};
    struct GreaterThanLong : TAO_PEGTL_ISTRING("greater-than"){};
    struct GreaterThan : pegtl::sor<GreaterThanShort, GreaterThanLong>{};

    struct GreaterOrEqualShort : TAO_PEGTL_ISTRING(">="){};
    struct GreaterOrEqualLong : TAO_PEGTL_ISTRING("greater-or-equal"){};
    struct GreaterOrEqual : pegtl::sor<GreaterOrEqualShort, GreaterOrEqualLong>{};

    struct EqualShort : TAO_PEGTL_ISTRING("=="){};
    struct EqualLong : TAO_PEGTL_ISTRING("equal"){};
    struct Equal : pegtl::sor<EqualShort, EqualLong>{};

    struct ComparisonOperator : pegtl::sor<LessOrEqual, GreaterOrEqual, GreaterThan, LessThan, Equal>{};

    struct Comment : pegtl::seq<pegtl::one<';'>, pegtl::until<pegtl::eolf>>{};

    struct String : pegtl::seq<pegtl::one<'"'>, pegtl::until<pegtl::one<'"'>>>{};
    struct SymbolName : pegtl::seq<pegtl::ranges<'a', 'z', 'A', 'Z'>, pegtl::star<pegtl::sor<pegtl::ranges<'a', 'z', 'A', 'Z'>, pegtl::one<'-'>>>>{};
    struct Number : pegtl::plus<pegtl::digit>{};

    struct StrategicNumber : pegtl::seq<TAO_PEGTL_ISTRING("sn-"), SymbolName>{};


    struct Value : pegtl::sor<String, Number, SymbolName>{};


    struct CallFuncTargetId : pegtl::seq<pegtl::one<'('>, MS, SymbolName, S, pegtl::sor<Number, SymbolName>, S, Number, MS, pegtl::one<')'>>{};
    struct CallFuncAction : pegtl::seq<pegtl::one<'('>, MS, SymbolName, MS, pegtl::one<')'>>{};
    struct SetSnAction : pegtl::seq<pegtl::one<'('>, MS, SymbolName, S, StrategicNumber, S, Value, MS, pegtl::one<')'>>{};
    struct CallFuncArgAction : pegtl::seq<pegtl::one<'('>, MS, SymbolName, S, Value, MS, pegtl::one<')'>>{};
    struct Action : pegtl::sor<CallFuncAction, SetSnAction, CallFuncArgAction, CallFuncTargetId>{};
    struct Actions : pegtl::plus<pegtl::seq<MS, Action, MS>>{};

    struct CompareIdValueCondition : pegtl::seq<pegtl::one<'('>, MS, SymbolName, S, Number, S, Number, MS, pegtl::one<')'>>{};
    struct GetAndCompareCondition : pegtl::seq<pegtl::one<'('>, MS, SymbolName, S, SymbolName, S, ComparisonOperator, S, Value, MS, pegtl::one<')'>>{};
    struct ComparisonCondition : pegtl::seq<pegtl::one<'('>, MS, SymbolName, S, ComparisonOperator, S, Value, MS, pegtl::one<')'>>{};
    struct CallCondition : pegtl::seq<pegtl::one<'('>, MS, SymbolName, S, Value, MS, pegtl::one<')'>>{};
    struct SimpleCondition : pegtl::seq<pegtl::one<'('>, MS, pegtl::opt<pegtl::seq<Not, S>>, SymbolName, MS, pegtl::one<')'>>{};
    struct Condition : pegtl::sor<GetAndCompareCondition, SimpleCondition, ComparisonCondition, CallCondition, CompareIdValueCondition>{};
    struct NegatedCondition : pegtl::seq<pegtl::one<'('>, MS, Not, S, Condition, MS, pegtl::one<')'>>{};
    struct OrCondition : pegtl::seq<pegtl::one<'('>, MS, Or, S, pegtl::plus<pegtl::seq<Condition, S>>, MS, pegtl::one<')'>>{};
    struct Conditions : pegtl::star<pegtl::seq<pegtl::sor<Condition, NegatedCondition, OrCondition>, S>>{};

    struct Rule : pegtl::seq<pegtl::one<'('>, RuleStart, S, Conditions, ConditionActionSeparator, S, Actions, pegtl::one<')'>>{};

    struct Grammar : pegtl::must<pegtl::star<pegtl::sor<Rule, Comment, S>>, pegtl::eof>{};

//   struct name : pegtl::plus< pegtl::alpha > {};
//   struct grammar : pegtl::must< prefix, name, pegtl::one< '!' >, pegtl::eof > {};
   // clang-format on

    template< typename Rule >
   struct action
   {};

   template<>
   struct action< SymbolName >
   {
      template< typename Input >
      static void apply( const Input& in, std::string& v )
      {
          DBG << "symbol name" << v << in.string();
      }
   };

   template<>
   struct action< SimpleCondition >
   {
      template< typename Input >
      static void apply( const Input& in, std::string& v )
      {
          DBG << "condition" << v << in.string();
      }
   };

   template<>
   struct action< S >
   {
      template< typename Input >
      static void apply( const Input& in, std::string& v )
      {
          DBG << "condition" << v << in.string();
      }
   };
}  // namespace hello

bool AiScriptParser::parse(const std::string &filename)
try // fucking exceptions
{
    if( pegtl::analyze< AiGrammar::Grammar >() != 0 ) {
        WARN << "failed to initialize grammar";
        return false;
    }
    DBG << "loaded grammar";

    pegtl::file_input in( filename );
    try{
        if (!pegtl::parse< AiGrammar::Grammar, pegtl::nothing, pegtl::tracer >( in )) {
            WARN << "failed to parse";
            return false;
        }
    } catch( const pegtl::parse_error& e ) {
        const auto p = e.positions.front();
        WARN << e.what() << pegtl::to_string(p);
    }

    return true;
}
catch (const std::exception &e) { WARN << e.what(); return false; }
