//
//  NaviteComissionerLogger.hpp
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 07/11/2022.
//

#include <stdio.h>
#include <commissioner/commissioner.hpp>

using namespace std;
using namespace ot::commissioner;

class TPComissionerLogger : public Logger {
public:
    ~TPComissionerLogger() = default;
    
    void Log(LogLevel aLevel, const std::string &aRegion, const std::string &aMsg) {
        printf("[ %s ]: %s", aRegion.c_str(), aMsg.c_str());
    }
};
