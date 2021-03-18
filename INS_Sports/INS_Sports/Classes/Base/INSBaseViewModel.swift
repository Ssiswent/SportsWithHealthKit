//
//  INSBaseViewModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

typealias SuccessBlock = (_ response: Any) -> Void
typealias FailureBlock = (_ error: Any) -> Void

class SSDataResponse {
    var isSuccess: Bool!
    var data: Any!
    
    init(isSuccess: Bool, data: Any) {
        self.isSuccess = isSuccess
        self.data = data
    }
}

class INSBaseViewModel:NSObject {
    
    var successHandler: SuccessBlock?
    var failedHandler: FailureBlock?
    
    func handleResponse(response: SSDataResponse) {
        if response.isSuccess {
            if let closure = successHandler {
                closure(response.data!)
            }
        } else {
            if let closure = failedHandler {
                closure(response.data!)
            }
        }
        clearReference()
    }

    public func success(_ closure: @escaping SuccessBlock) -> Self {
        successHandler = closure
        return self
    }
    
    @discardableResult
    public func failed(_ closure: @escaping FailureBlock) -> Self {
        failedHandler = closure
        return self
    }
    
    func clearReference() {
        successHandler = nil
        failedHandler = nil
    }
    
}
