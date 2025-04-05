//
//  DashboardViewModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 13/06/23.
//

import Foundation

enum EmotionTypes: Int , CaseIterable
{
    
    case focus      = 1
    case relax      = 2
    case hangout    = 3
    case sleep      = 4
    
    init?(rawValue: String) {
        
        switch rawValue {
        case "Focus" : self = .focus
        case "Relax" : self = .relax
        case "Hang Out" : self = .hangout
        case "Sleep" : self = .sleep
        default:
            self = .focus
        }
        
    }
    
    var animationName: String {
        ///using video file names to play animation
        get {
            switch self {
            case .focus:
                return "Focus"
            case .relax:
                return "Relax"
            case .hangout:
                return "Hang Out"
            case .sleep:
                return "Sleep"
            }
        }
    }
    
    var iconName: String {
        get {
            switch self {
            case .focus:
                return "Focus_icon"
            case .relax:
                return "Relax_icon"
            case .hangout:
                return "Hangout_icon"
            case .sleep:
                return "Sleep_icon"
            }
        }
    }
    
    var colorHex: String {
        get {
            switch self {
            case .focus:
                return "DBF5FF"
            case .relax:
                return "E7DCF4"
            case .hangout:
                return "FFF3E0"
            case .sleep:
                return "E5FFE0"
            }
        }
    }
}

class DashboardViewModel
{
    private var networkCall: NetworkCall!
    
    private (set) var categories: [Categories] = []
    private (set) var history: [HistoryModel] = []

    func getAllCategories(success: @escaping ResponseCompletion, fail: @escaping ResponseCompletion)
    {
        
        let apiUrl = Utility.shared.getCurrentUserToken() == "" ? NetworkCall.APIServices.categoriesGuest : NetworkCall.APIServices.categories
        
        networkCall = NetworkCall(data: [:], headers: Utility.shared.getDefaultHeaders(), service: apiUrl, method: .get,isJSONRequest: false)
        
        networkCall.executeQuery { result in
            
            switch  result{
                
            case .success(let value):
                if let response = value as? [String: Any]
                {
                    let statusCode = response["status"] as? Int ?? 0
                    let message = response["message"] as? String ?? ""

                    if statusCode == 200
                    {
                        let data = response["data"] as? [String: Any] ?? [:]
                        let categories = data["categories"] as? [[String: Any]] ?? []
                        let history = data["history"] as? [[String: Any]] ?? []
                        
                        var catsObj = [Categories]()
                        var historyObj = [HistoryModel]()

                        categories.forEach { categories in
                            catsObj.append(Categories(dict: categories))
                        }
                        
                        history.forEach { his in
                            historyObj.append(HistoryModel(dict: his))
                        }
                        
                        self.categories = catsObj.sorted(by: {($0.id ?? 0) < ($1.id ?? 0)})
                        self.history = historyObj.reversed()
                        
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
