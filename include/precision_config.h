#pragma once
#include <string>

namespace bevdet_precision {
    extern std::string current_precision;
    
    void setPrecision(const std::string& precision);
    bool isFloat16();
}
