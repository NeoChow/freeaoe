#ifndef DRIVER_HH
# define DRIVER_HH
# include <string>
# include <map>

#include <iostream>

#include "location.hh"

namespace ai {
    class ScriptLoader {
    public:
        ScriptLoader() {};
        virtual ~ScriptLoader() {};

        int parse(std::istream& in, std::ostream& out);
    };
}

#endif // ! DRIVER_HH


