//
//  ServicesInterface.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

protocol ServicesDelegate{
    
    associatedtype GenericTypeOne
    associatedtype GenericTypeTwo
    
    func tvShowDetailApi(showId: Int?, completion: @escaping (Result<(ShowDetailResponse?, Int?), Error>) -> ())
    func seasonDetailApi(seasonNo: Int?, showId: Int?, completion: @escaping (Result<(SeasonModel?, Int?), Error>) -> ())
    
    func getResponse(_ type: RequestType, ignoreBaseUrl: Bool, endPoint: String, parameters: [String: Any]?, customHeaders: [String: String]?, isMultiPartData: ParameterType?, rawData: String?, files: FileParameters?, completion: @escaping (Result<(GenericTypeOne?, GenericTypeTwo?), Error>)->())
    
}

extension ServicesDelegate {
    
    func tvShowDetailApi(showId: Int?, completion: @escaping (Result<(ShowDetailResponse?, Int?), Error>) -> ()) {
        completion(.failure(NSError(domain: "Default Tv show detail API implementation", code: -1)))
    }
    
    func seasonDetailApi(seasonNo: Int?, showId: Int?, completion: @escaping (Result<(SeasonModel?, Int?), Error>) -> ()) {
        completion(.failure(NSError(domain: "Default Season detail API implementation", code: -1)))
    }
    
}
