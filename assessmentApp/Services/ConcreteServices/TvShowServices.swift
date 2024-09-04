//
//  TvShowServices.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

class TvShowDetailService: ServicesDelegate {
    
    func tvShowDetailApi(showId: Int?, completion: @escaping (Result<(ShowDetailResponse?, Int?), Error>) -> ()) {
        var params: [String] = []
        var endPoint: String = EndPoint.tvShowDetailApi.rawValue
        let key: String? = servicesInitilizationManager?.listManager.readAkData()
        params.append("api_key=\(key ?? "")")
        let quertyParameters: String = QueryParamMaker.makeQueryParam(params: params)
        if let showId {
            endPoint += "/\(showId)"
        }
        getResponse(.get, endPoint: endPoint + quertyParameters, completion: completion)
    }
    
    func getResponse(_ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(ShowDetailResponse?, Int?), Error>) -> ()) {
        API.shared.api(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: ShowDetailResponse.self) { result in
            switch result {
            case .success((let data, let resp)):
                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
                completion(.success((data, resp.statusCode)))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
}

class SeasonDetailService: ServicesDelegate {
    
    func seasonDetailApi(seasonNo: Int?, showId: Int?, completion: @escaping (Result<(SeasonModel?, Int?), Error>) -> ()) {
        var params: [String] = []
        var endPoint: String = EndPoint.tvShowDetailApi.rawValue
        let key: String? = servicesInitilizationManager?.listManager.readAkData()
        params.append("api_key=\(key ?? "")")
        let quertyParameters: String = QueryParamMaker.makeQueryParam(params: params)
        if let showId {
            endPoint += "/\(showId)"
        }
        if let seasonNo {
            endPoint += "/season/\(seasonNo)"
        }
        getResponse(.get, endPoint: endPoint + quertyParameters, completion: completion)
    }
    
    func getResponse(_ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(SeasonModel?, Int?), Error>) -> ()) {
        API.shared.api(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: SeasonModel.self) { result in
            switch result {
            case .success((let data, let resp)):
                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
                completion(.success((data, resp.statusCode)))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
}
