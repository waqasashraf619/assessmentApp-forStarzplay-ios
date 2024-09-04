//
//  API.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//


/*
 This Network layer is my own written middleware which I refiend throughout the course of my career
 */

import Foundation
import UniformTypeIdentifiers
import MobileCoreServices

enum AppSpecificError: Error{
    case cannotConvertToHttpReponse
    case cannotParseData(_ statusCode: Int)
}

extension AppSpecificError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotConvertToHttpReponse:
            return NSLocalizedString("Error converting httpResponse to HTTPURLResponse", comment: "PlexaarSpecificError")
        case .cannotParseData:
            return NSLocalizedString("Cannot read data", comment: "PlexaarSpecificError")
        }
    }
}

let baseUrlDomain = BaseUrl.dataBaseUrl.rawValue
let imageUrlDomain = BaseUrl.imageBaseUrl.rawValue
let baseUrl = "\(baseUrlDomain)"
let imageBaseUrl = "\(imageUrlDomain)"

enum RequestType: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum ParameterType{
    case multiPartFormData
}

struct FileParameters{
    var fileName: String
    var urls: [URL]
}

//MARK: - API
class API: APIServiceDelegate{
    
    static let shared = API()
    
    func downloadApi(endpoint: String, fileType: String? = nil, completion: @escaping (Result<(URL, HTTPURLResponse), Error>)->()){
        
        guard let inputUrl = URL(string: endpoint) else { return }
        let request = URLRequest(url: inputUrl)
        CacheManager.shared.getFileWith(stringUrl: endpoint, fileType: fileType) { result in
            
            switch result {
            case .success(let url):
                // do some magic with path to saved video
                print("Media already exists: \(url)")
                completion(.success((url, HTTPURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))))
            case .failure(_):
                // handle errror
                print("Download Media")
                URLSessionMaker.shared.downloadApiCall(request: request, completion: completion)
            }
        }
        
    }
    
    // API call
    func api<T: Codable>(type: RequestType? = nil, ignoreBaseUrl: Bool = false, endpoint: String, parameters: [String: Any]? = nil, customHeaders: [String: String]? = nil, urlSessionConfiguration: URLSessionConfiguration? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, expecting: T.Type, completion: @escaping (Result<(T, HTTPURLResponse), Error>)->()){
        
        
        guard let request = UrlRequestMaker.makeRequest(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endpoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files) else{
            
            //For debugging
            print("Some issue occured while creating request")
            
            return
        }
        
        //URL Session Configuration
        var config: URLSessionConfiguration = URLSessionConfiguration.default
        
        if let urlSessionConfiguration{
            config = urlSessionConfiguration
        }
        else{
            ///`false`: Cancels the request if the internet connect goes away
            config.waitsForConnectivity = false
            
            ///Time out setting if response takes more than 10 seconds
//            config.timeoutIntervalForResource = 10
        }
        
        config.httpAdditionalHeaders = [
            "Accept" : "application/json"
        ]
        
        // Using url session to hit end-point
        URLSessionMaker.shared.apiCall(request: request, urlSessionConfiguration: config, expecting: expecting, completion: completion)
        
    }
     
}

//MARK: UrlRequestMaker
class UrlRequestMaker{
    
    class func makeRequest(type: RequestType? = nil, ignoreBaseUrl: Bool = false, endpoint: String, parameters: [String: Any]? = nil, customHeaders: [String: String]? = nil,isMultiPartData: ParameterType? = nil, rawData: String?, files: FileParameters? = nil) -> URLRequest?{
        
        let boundary = String(format: "net.3lvis.networking.%08x%08x", arc4random(), arc4random())
        
        var requestType = ""
        
        guard let url: URL = URL(string: ignoreBaseUrl ? endpoint : baseUrl + endpoint) else{
            return nil
        }
        var request = URLRequest(url: url)
        
        //Setting token
        /*
         if let token = appAuthToken{
             request.addValue("Bearer \(token)", forHTTPHeaderField: HttpHeaderKey.authorization.rawValue)
         }
         */
        
        //Setting Custom Header
        if let customHeaders = customHeaders {
            for (key, value) in customHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            //For debugging
            print("Custom header is: \(customHeaders)")
        }
        
        // Setting request type
        switch type {
        case .post, .put, .delete, .patch, .get:
            requestType = type?.rawValue ?? .init()
        case .none:
            requestType = "GET"
        }
        
        request.httpMethod = requestType
        
        //For debugging
        print("Request type is: \(requestType)")
        print("Endpoint is: \(url.absoluteString)")
//        Logger.network("Current token: \(String(describing: token))")
        
        //To Log/Debug parameters
        LogApi.shared.logParameters(parameters: parameters)
        print("Parameters are: \(String(describing: parameters))")
        print("Time Zone is: \(String(describing: TimeZone.current.identifier))")
        print("All API headers are: \(String(describing: request.allHTTPHeaderFields))")
        print("Raw data inside API call is: \(rawData ?? "")")
        
        if requestType != "GET"{
            
            
            if isMultiPartData != nil{
                // if it is Multipart form data
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                //Form data Body & Request Maker
                let bodyData = MultiPartRequestBodyHandler.setUrlRequest(parameters: parameters, urls: files, boundary: boundary)
                
                request.httpBody = bodyData
                
            }
            else{
                
                do {
                    if let rawData{
//                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.httpBody = rawData.data(using: .utf8)
                    }
                    else{
                        // if it is json data
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters ?? .init())
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        return request
        
    }
    
}


//MARK: - URLSessionMaker
class URLSessionMaker{
    
    static let shared = URLSessionMaker()
    
    func downloadApiCall(request: URLRequest, completion: @escaping (Result<(URL, HTTPURLResponse), Error>)->()){
        let downloadTask = URLSession.shared.downloadTask(with: request) { url, response, error in
            print("Download Task complete.")
            if let response = response, let url = url,
               let data = try? Data(contentsOf: url) {
                completion(.success((url, response as! HTTPURLResponse)))
                print("Download response: \(response)\nDownload url: \(url)")
            }
            if let error{
                print("Download error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        downloadTask.resume()
    }

    func apiCall<T: Codable>(request: URLRequest, urlSessionConfiguration: URLSessionConfiguration, expecting: T.Type,completion: @escaping (Result<(T, HTTPURLResponse), Error>)->()){

        // Using url session to hit end-point
        let task = URLSession(configuration: urlSessionConfiguration).dataTask(with: request) { data, resp, error in
            
            // Reading status code For debugging
            print("Parse response is: \(resp as Any)")
            
            //For debugging
            LogApi.shared.logApiResponse(inputData: data, endPoint: request.url?.absoluteString ?? "", response: resp)
            
            //MARK: NetworkErrorHandling
            if let networkError = error as? URLError{
                ActivityIndicator.shared.removeActivityIndicator()
                print("Network error code: \(networkError.code.rawValue), Info: \(networkError.localizedDescription)")
                DispatchQueue.main.async {
//                    GenericToast.showToast(message: networkError.localizedDescription)
                }
                completion(.failure(networkError))
            }
            
            if let httpResponse = resp as? HTTPURLResponse {
                
                //Handle session
                self.checkAuthorization(statusCode: httpResponse.statusCode, request: request, urlSessionConfiguration: urlSessionConfiguration, expecting: expecting, completion: completion)
            }
            
            guard let data = data, let resp = resp else {
                return
            }
            do{
                // Decode/Parse data
                let result = try ParsingHandler.shared.parser(data: data, expected: expecting)
                
                //Return Decoded result
                completion(.success((result, (resp as! HTTPURLResponse))))

            }
            catch {
                //For debugging
                let response = resp as! HTTPURLResponse
                print("Error response is: \(response), Error other respone: \(resp)")
                
                //Show parsing error toast
                DispatchQueue.main.async {
                    if response.statusCode != StatusCode.sessionUnAuth.rawValue {
                        //Remove Progress bar
                        ActivityIndicator.shared.removeActivityIndicator()
//                        GenericToast.showToast(message: "\(response.statusCode): \(error.localizedDescription)")
                    }
                }
                //Return error
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: Check authorization
    
    private func checkAuthorization<T: Codable>(statusCode: Int, request: URLRequest, urlSessionConfiguration: URLSessionConfiguration, expecting: T.Type, completion: @escaping (Result<(T, HTTPURLResponse), Error>)->()){
        DispatchQueue.main.async {
            guard !UnAuthorizationHandler.isUnAuthorizationErrorCode(statusCode, isFirst: false, request: request, urlSessionConfiguration: urlSessionConfiguration, expecting: expecting, completion: completion) else {
                return
            }
        }
    }
    
}

//MARK: - MultiPartRequestBodyHandler
class MultiPartRequestBodyHandler{
    
    static func setUrlRequest(parameters: [String: Any]?, urls: FileParameters?, boundary: String) -> Data?{
        
        print("File urls: \(String(describing: urls))")
        
        var data: Data?
        
        if let parameters{
            data = Data()
            parameters.forEach { (key, value) in
                data?.append("--\(boundary)\r\n")
                data?.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                data?.append("\(value)\r\n")
            }
        }
        
        
        if let urls = urls{
            for url in urls.urls {
                let filename = url.lastPathComponent
                do {
                    if data == nil{
                        data = Data()
                    }
                    let fileData = try Data(contentsOf: url)
                    data?.append("--\(boundary)\r\n")
                    data?.append("Content-Disposition: form-data; name=\"\(urls.fileName)\"; filename=\"\(filename)\"\r\n")
                    
                    //Setup Content-Type using ContentTypeHandler
                    let contentType = ContentTypeHandler.setContentType(fileUrl: url)
                    data?.append("Content-Type: \(contentType)\r\n\r\n")
                    
                    //For debugging
                    print("Mime/Content type is: \(contentType), file name is: \(urls.fileName)")
                    
                    data?.append(fileData)
                    data?.append("\r\n")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        data?.append("--\(boundary)--\r\n")
        
        return data
    }
    
}

//MARK: - ParsingHandler
class ParsingHandler{
    
    static let shared = ParsingHandler()
    
    func parser<T: Codable>(data: Data, expected: T.Type) throws -> T{
        
        let result = try JSONDecoder().decode(expected, from: data)
        return result
        
    }
    
    func encodeItem<T: Codable>(item: T) -> Data?{
        do {
            let encoded = try JSONEncoder().encode(item)
            print("Encoded successfully \(encoded)")
            return encoded
        } catch  {
            print("Encoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func encodeAnyItem(item: [String: Any]) -> Data?{
        do {
            let encodedData = try JSONSerialization.data(withJSONObject: item)
            print("Encoded successfully \(encodedData)")
            return encodedData
        } catch {
            print("Encoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
}

//MARK: - ContentTypeHandler
class ContentTypeHandler{
    
    static func setContentType(fileUrl: URL) -> String{
        
        let mimeTypes = Bundle.main.path(forResource: "mimeTypes", ofType: "json")
        let typeName = fileUrl.pathExtension
        
        if let mimeTypes = mimeTypes{
            let mimeData = NSData(contentsOfFile: mimeTypes) as? Data
            if let mimeData = mimeData{
                
                do {
                    let contentTypes = try ParsingHandler.shared.parser(data: mimeData, expected: [ContentType].self)
                    for contentType in contentTypes{
                        
                        //For debugging
                        print("Content type is: \(contentType)")
                        print("File type is: \(typeName), content name is: \(contentType.name)")
                        
                        if typeName == contentType.name{
                            
                            //for debugging
                            print("The file's content type is: \(String(describing: contentType.template))")
                            
                            //Return mimeType/Content-Type,  e.g: image/png, video/3gpp, text/html
                            return contentType.template
                        }
                    }
                } catch {
                    //For debugging
                    print("Content type json parsing error: \(error.localizedDescription)")
                    
                    return "application/octet-stream"
                }
            }
            else{
                return "application/octet-stream"
            }
        }
        else{
            return "application/octet-stream"
        }
        return "application/octet-stream"
    }
    
}

//MARK: - Data Extension
extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

//MARK: - URL Extension


struct ContentType: Codable{
    
    let name, template, refrence: String
    
    enum CodingKeys: String, CodingKey{
        case name = "Name"
        case template = "Template"
        case refrence = "Reference"
    }
    
}

public enum CacheResult<T> {
    case success(T)
    case failure(NSError)
}

//MARK: LogResponse
class LogApi{
    
    static let shared: LogApi = LogApi()
    
    func logParameters(parameters: [String: Any]?){
        if let parameters {
            // Serialize to JSON
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            
            // Convert to a string and print
            if let JSONString = String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) {
                print("Parameters are (JSON): \(JSONString)")
            }
        }
    }
    
    func logApiResponse(inputData: Data?, endPoint: String, response: URLResponse?){
        
        
        var statusCode: String = ""
        if let httpResponse = response as? HTTPURLResponse{
            statusCode += " with Status Code: \(httpResponse.statusCode)"
        }
        var str = "API \(endPoint)\(statusCode) Response 💚💚💚💚 \n"
        var finalLog: String = "\(str)"
        
        if let inputData {
            if let parsedJsonData = try? JSONSerialization.jsonObject(with: inputData, options: []) as? [String: Any] {
                // Serialize to JSON
                let jsonData = try? JSONSerialization.data(withJSONObject: parsedJsonData)
                
                // Convert to a string and print
                if let JSONString = String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) {
                    finalLog += " \(JSONString)"
                }
            }
            else {
                let htmlResponse = inputData.html2String
                finalLog += " \(htmlResponse)"
            }
        }
        
        print(finalLog)
        
    }
}

//MARK: ManageCache
class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    func getFile(stringUrl: String, fileType: String? = nil) -> URL?{
        let file = directoryFor(stringUrl: stringUrl, fileType: fileType)
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            return file
        }
        
        return nil
    }

    func getFileWith(stringUrl: String, fileType: String? = nil, completionHandler: @escaping (CacheResult<URL>) -> Void ) {


        let file = directoryFor(stringUrl: stringUrl, fileType: fileType)

        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(CacheResult.success(file))
            return
        }

        DispatchQueue.global().async {

            if var fileData = NSData(contentsOf: URL(string: stringUrl)!) {
                
                fileData.write(to: file, atomically: true)
                DispatchQueue.main.async {
                    completionHandler(CacheResult.success(file))
                }
            }
            else {
                DispatchQueue.main.async {
                    completionHandler(CacheResult.failure(NSError(domain: "Can't download video", code: 619)))
                }
            }
        }
    }

    private func directoryFor(stringUrl: String, fileType: String? = nil) -> URL {

        let fileURL = URL(string: stringUrl)!.lastPathComponent
        print("File path to be saved: \(fileURL)")
        if let fileType{
            print("Change File path change to: \(fileURL).\(fileType)")
            let file = self.mainDirectoryUrl.appendingPathComponent("\(fileURL).\(fileType)")
            return file
        }
        else{
            let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
            return file
        }
    }
    
}

class ErrorHandler{
    
    static func displayError(_ error: Error){
        if let error = error as? AppSpecificError{
            switch error {
            case .cannotConvertToHttpReponse:
                print(error.localizedDescription)
            case .cannotParseData(let statusCode):
                print("\(error.localizedDescription) -> StatusCode: \(statusCode)")
            }
        }
        else{
            print(error.localizedDescription)
        }
    }
    
}

//MARK: QueryParamMaker
class QueryParamMaker {
    
    static func makeQueryParam(params: [String]?) -> String{
        var queryParams: String = ""
        if let params {
            for (index, param) in params.enumerated() {
                let connectingSymbol: String = index == 0 ? "?" : "&"
                queryParams += "\(connectingSymbol)\(param)"
            }
        }
        return queryParams
    }
    
}

//MARK: HtmlParser
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}


extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}

//MARK: API Interfaces
protocol APIServiceDelegate: AnyObject{
    func api<T: Codable>(type: RequestType?, ignoreBaseUrl: Bool, endpoint: String, parameters: [String: Any]?, customHeaders: [String: String]?, urlSessionConfiguration: URLSessionConfiguration?, isMultiPartData: ParameterType?, rawData: String?, files: FileParameters?, expecting: T.Type, completion: @escaping (Result<(T, HTTPURLResponse), Error>)->())
}

protocol UrlRequestMakerDelegate: AnyObject{
    
}
