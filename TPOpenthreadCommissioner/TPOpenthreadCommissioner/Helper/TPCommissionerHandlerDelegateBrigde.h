//
//  TPCommissionerHandlerDelegateBrigde.h
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 07/11/2022.
//

#include <stdio.h>
#include <commissioner/commissioner.hpp>

#include "TPCommissionerHandlerDelegate.h"

using namespace std;
using namespace ot::commissioner;

class TPCommissionerHandlerDelegateBrigde : public CommissionerHandler {
public:
    ~TPCommissionerHandlerDelegateBrigde() = default;
    TPCommissionerHandlerDelegateBrigde(id<TPCommissionerHandlerDelegate> aDelegate) : mTPCommissionerHandlerDelegate(aDelegate) {}
    
private:
    id<TPCommissionerHandlerDelegate> mTPCommissionerHandlerDelegate;
};
