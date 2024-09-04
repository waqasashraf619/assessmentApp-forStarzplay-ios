//
//  UnAuthorizationHandler.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit

enum StatusCode: Int{
    
    case unAuthorized = 403
    case sessionUnAuth = 401
    case appUpdate = 406
    
}

class UnAuthorizationHandler {
    
    class func isUnAuthorizationErrorCode<T: Codable>(_ code : Int, isFirst: Bool? = nil, request: URLRequest, urlSessionConfiguration: URLSessionConfiguration, expecting: T.Type, completion: @escaping (Result<(T, HTTPURLResponse), Error>)->()) ->  Bool {
        
        //        return true
        let statusCode: StatusCode? = StatusCode(rawValue: code)
        switch statusCode {
        case .unAuthorized:
            setRootController(statusCode: code, message: "Un-Authorized")
            return true
        case .sessionUnAuth:
            refreshToken(request: request, urlSessionConfiguration: urlSessionConfiguration, expecting: expecting, completion: completion)
            return true
        case .appUpdate, .none:
            print("Do nothing")
            return false
        }
        
    }
    
    class func setRootController(statusCode: Int, isFirst: Bool? = nil, message: String) {
        
        
    }
    
    class func refreshToken<T: Codable>(request: URLRequest, urlSessionConfiguration: URLSessionConfiguration, expecting: T.Type, completion: @escaping (Result<(T, HTTPURLResponse), Error>)->()){
        
        
    }
    
}
    

