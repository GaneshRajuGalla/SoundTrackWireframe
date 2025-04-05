//
//  NetworkCall.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import Foundation
import Alamofire
import NVActivityIndicatorView
import UIKit

class NetworkCall : NSObject{
    
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var baseUrl :String! = Constants.baseUrl
    var encoding: ParameterEncoding! = JSONEncoding.default
    
    init(data: [String:Any],headers: [String:String] = [:],url :String? = nil,service :APIServices? = nil, method: HTTPMethod = .post, isJSONRequest: Bool = true){
        super.init()
        data.forEach{parameters.updateValue($0.value, forKey: $0.key)}
        headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
        if url == nil, service != nil {
            self.baseUrl += service!.rawValue
        } else{
            self.baseUrl += url!
        }
        if !isJSONRequest{
            encoding = URLEncoding.default
        }
        self.method = method
        print("Service: \(service?.rawValue ?? self.baseUrl ?? "") \n Parameters: \(parameters)")
    }
    
    
    func executeQuery(completion: @escaping (Result<Any, Error>) -> Void,progress: @escaping ((Int) -> Void) = { _ in } )  {

        Logger.log("Api Url : \(baseUrl ?? "")")
        Logger.log("headers : \(headers)")

        AF.request(baseUrl,method: method,parameters: parameters,encoding: encoding, headers: headers).responseData(completionHandler: { response in

            switch response.result{
            case .success(let res):
                if let code = response.response?.statusCode{
                    switch code {
                    case 200...299:
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: res, options: .mutableLeaves)
                            Logger.log(jsonObject)

                            if let object = jsonObject as? [String: Any], let status_Code = object["status_code"] as? Int, status_Code == 401{
                                Utility.shared.displayAlertWithCompletion(title: "", message: "User Session Expired please login again!", controls: [GlobalProperties.AppMessages.okAction]) { action in
                                    Utility.shared.deleteCurrentUserDetails()
                                    Utility.shared.makeWelcomeRoot()
                                }
                            }
                            completion(.success(jsonObject))
                        } catch let error {
                            Logger.log(String(data: res, encoding: .utf8) ?? "nothing received")
                            completion(.failure(error))
                        }
                    default:

                        do {
                            Logger.log(String(data: res, encoding: .utf8) ?? "nothing received")

                            let jsonObject = try JSONSerialization.jsonObject(with: res, options: .mutableLeaves)

                            if let object = jsonObject as? [String: Any], let status_Code = object["status_code"] as? Int, status_Code == 401{
                                Utility.shared.displayAlertWithCompletion(title: "", message: "User Session Expired please login again!", controls: [GlobalProperties.AppMessages.okAction]) { action in
                                    Utility.shared.deleteCurrentUserDetails()
                                    Utility.shared.makeWelcomeRoot()
                                }
                            }

                            completion(.success(jsonObject))
                        } catch let error {
                            Logger.log(String(data: res, encoding: .utf8) ?? "nothing received")
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func mimeType(for data: Data) -> String {

        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)

        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
}
