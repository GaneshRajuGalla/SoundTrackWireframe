//
//  AppleSignIn.swift
//  sourmind
//
//  Created by Ajay Rajput on 21/12/22.
//

import Foundation
import UIKit
import AuthenticationServices

struct SocialUser
{
    var email = ""
    var fName = ""
    var lName = ""
    var identifier = ""
    
    var fullName: String? {
        get {
            if lName != ""{
                return "\(fName) \(lName)"
            }
            return fName
        }
    }
    
}

class AppleSignIn: NSObject
{
    static let  shared = AppleSignIn()
    var complitionHandler: ((SocialUser?, String?)->())?
        
    func signInButtonAction(completion: @escaping (SocialUser?, String?) -> ()) {

        if #available(iOS 13.0, *) {
            self.complitionHandler = completion
            let authorizationProvider = ASAuthorizationAppleIDProvider()
            let request = authorizationProvider.createRequest()
            request.requestedScopes = [.email, .fullName]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
            complitionHandler?(nil, "Need iOS version greater than 13.0 for Apple Sign in or SignUp")
        }
        
    }
}

@available(iOS 13.0, *)
extension AppleSignIn: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
//        print("AppleID Credential Authorization: userId: \(appleIDCredential.user), email: \(String(describing: appleIDCredential.email)),  name: \(String(describing: appleIDCredential.fullName))")
        let dataBlank = "".data(using: .utf8)
        if appleIDCredential.email != nil {
            //Save data to keychain
            _ = KeyChain.save(key: "email", data: appleIDCredential.email?.data(using: .utf8) ?? dataBlank!)
            _ = KeyChain.save(key: "fName", data: appleIDCredential.fullName?.givenName?.data(using: .utf8) ?? dataBlank!)
            _ = KeyChain.save(key: "lName", data: appleIDCredential.fullName?.familyName?.data(using: .utf8) ?? dataBlank!)
        }
        
        var user =  SocialUser()
        user.email = appleIDCredential.email ?? String(decoding: KeyChain.load(key: "email") ?? dataBlank!, as: UTF8.self)
        user.fName = appleIDCredential.fullName?.givenName ?? String(decoding: KeyChain.load(key: "fName") ?? dataBlank!, as: UTF8.self)
        user.lName = appleIDCredential.fullName?.familyName ?? String(decoding: KeyChain.load(key: "lName") ?? dataBlank!, as: UTF8.self)
        user.identifier = appleIDCredential.user
        complitionHandler?(user, nil)
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        complitionHandler?(nil, error.localizedDescription)
        print("AppleID Credential failed with error: \(error.localizedDescription)")
        
    }
}

@available(iOS 13.0, *)
extension AppleSignIn: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!
    }
}

// Keychain Extension to store user data on first use.
class KeyChain {
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
}

