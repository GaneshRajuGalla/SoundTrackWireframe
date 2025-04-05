//
//  MenuViewModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 29/08/23.
//

import Foundation

class MenuViewModel
{
    private var networkCall: NetworkCall!
    
    var staticContent : String = ""

    func getStaticContent(slug: String, success: @escaping ResponseCompletion, fail: @escaping ResponseCompletion)
    {
        
        let apiUrl = NetworkCall.APIServices.staticPage
        
        networkCall = NetworkCall(data: [:], headers: Utility.shared.getDefaultHeaders(),url: apiUrl.rawValue + slug, method: .get,isJSONRequest: false)
        
        networkCall.executeQuery { result in
            
            switch  result{
                
            case .success(let value):
                if let response = value as? [String: Any]
                {
                    let statusCode = response["status"] as? Int ?? 0
                    let message = response["message"] as? String ?? ""

                    if statusCode == 200
                    {
                        let data = response["data"] as? String ?? ""
                        self.staticContent = data
                        success(message)
                    }else{
                        fail(message)
                    }
                    
                }else{
                    
                    fail(GlobalProperties.AppMessages.somethingWentWrong)
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription)
                fail(error.localizedDescription)
            }
        }
        
    }
    
    
}
