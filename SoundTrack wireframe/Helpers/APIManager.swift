//
//  APIManager.swift
//  SoundTrack wireframe
//
//  Created by Naveen Kumar on 08/09/23.
//

import UIKit
import Foundation
import Alamofire
import AVFoundation
import SVProgressHUD

class APIManager: NSObject {
    
    static let shared = APIManager()
    
    func fetchData(urlString: String, dict: [String:Any], requestType: HTTPMethod, view: UIViewController, isLoaderShown: Bool = true, completion: @escaping (Any) -> (), failure: @escaping(String)->()){
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        print("parameter -> \(dict)")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utility.shared.getCurrentUserToken())",
        ]
        if Connectivity.isConnectedToInternet(){
            (isLoaderShown == true) ? SVProgressHUD.show() : nil
            AF.request(url, method: requestType, parameters: dict, encoding: URLEncoding.default , headers: headers).responseJSON { (response: AFDataResponse<Any>) in
                SVProgressHUD.dismiss()
                print(response.result)
                switch(response.result){
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    failure(error.localizedDescription)
                    Logger.log(error.localizedDescription)
                }
            }
        }else {
            Utility.shared.showAlert(title: "", msg: "Please connect to the internet", vwController: view)
        }
        
    }
}
