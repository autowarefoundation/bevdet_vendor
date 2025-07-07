#include "precision_config.h"

namespace bevdet_precision {
    std::string current_precision = "fp16"; // Default to FP16
    
    void setPrecision(const std::string& precision) {
        current_precision = precision;
    }
    
    bool isFloat16() {
        return current_precision == "fp16";
    }
}
