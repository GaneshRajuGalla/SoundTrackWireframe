//
//  UserDefaultManager.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 10/04/25.
//

import Foundation

class UserDefaultManager: NSObject {
    
    // MARK: - Properties
    static let shared = UserDefaultManager()
    private let userDefaults: UserDefaults?
    
    // MARK: - Init
    private override init() {
        self.userDefaults = UserDefaults()
    }
    
    func set<T>(_ obj: T, for key: UserDefaultsKey) {
        self.userDefaults?.set(obj, forKey: key.value)
        self.userDefaults?.synchronize()
    }
    
    func get<T>(for key: UserDefaultsKey) -> T? {
        let result = self.userDefaults?.object(forKey: key.value) as? T
        return result
    }
    
    func remove(for key: UserDefaultsKey) {
        self.userDefaults?.removeObject(forKey: key.value)
        self.userDefaults?.synchronize()
    }
    
    private func object(for key: UserDefaultsKey) -> Any? {
        let result = self.userDefaults?.object(forKey: key.value)
        return result
    }
    
    static func purge() {
        let keys = UserDefaultsKey.allCases
        keys.forEach {
            let excluded = UserDefaultsKey.excludedCases.contains($0)
            if excluded {
                print("Excluded case: \($0.value)")
            } else {
                UserDefaultManager.shared.remove(for: $0)
            }
        }
    }
}

enum UserDefaultsKey: String, CaseIterable {
    case isSubscribed = "IS_SUBSCRIBED"
   
    // define keys excluded keys for cleaning userDefaults
    static var excludedCases: [UserDefaultsKey] = []
    
    var value: String {
        return self.rawValue
    }
}

