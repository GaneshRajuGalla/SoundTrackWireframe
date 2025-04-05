//
//  Dictionary+extensions.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import Foundation

extension Dictionary {

    func removeNull() -> Dictionary {
        let mainDict = NSMutableDictionary.init(dictionary: self)
        for _dict in mainDict {
            if _dict.value is NSNull {
                mainDict.removeObject(forKey: _dict.key)
            }
            if _dict.value is NSDictionary {
                let test1 = (_dict.value as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
                let mutableDict = NSMutableDictionary.init(dictionary: _dict.value as! NSDictionary)
                for test in test1 {
                    mutableDict.removeObject(forKey: test.key)
                }
                mainDict.removeObject(forKey: _dict.key)
                mainDict.setValue(mutableDict, forKey: _dict.key as? String ?? "")
            }
            if _dict.value is NSArray {
                let mutableArray = NSMutableArray.init(object: _dict.value)
                for (index,element) in mutableArray.enumerated() where element is NSDictionary {
                    let test1 = (element as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
                    let mutableDict = NSMutableDictionary.init(dictionary: element as! NSDictionary)
                    for test in test1 {
                        mutableDict.removeObject(forKey: test.key)
                    }
                    mutableArray.replaceObject(at: index, with: mutableDict)
                }
                mainDict.removeObject(forKey: _dict.key)
                mainDict.setValue(mutableArray, forKey: _dict.key as? String ?? "")
            }
        }
        return mainDict as! Dictionary<Key, Value>
    }
 }
