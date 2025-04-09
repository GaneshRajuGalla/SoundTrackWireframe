//
//  AuthViewModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 12/06/23.
//

import Foundation
import UIKit
import SuperwallKit

enum LoginTypes: String
{
    ///All Login types of App
    case apple      = "apple"
    case google     = "google"
    case facebook   = "facebook"
    case email      = "email"
}

class AuthViewModel
{
    private var networkCall: NetworkCall!
        
    func signInWithApple(success: @escaping ResponseCompletion, fail: @escaping ResponseCompletion)
    {
        AppleSignIn.shared.signInButtonAction { user, error in
            if let user = user
            {
                self.loginWithSocialAccount(name: user.fullName ?? user.fName, email: user.email, socialId: user.identifier, success: success, fail: fail)
            }
        }
    }
    
    func signInWithGoogle(view: UIViewController,success: @escaping ResponseCompletion, fail: @escaping ResponseCompletion){
        GoogleSignInHandler.shared.handleSignInButton(presentingView: view) { user, error in
            if let user = user
            {
                self.loginWithSocialAccount(type: .google,name: user.fullName ?? user.fName, email: user.email, socialId: user.identifier, success: success, fail: fail)
            }
        }
    }
    
    func signInWithFacebook(view: UIViewController,success: @escaping ResponseCompletion, fail: @escaping ResponseCompletion)
    {
        FacebookSignInHelper.shared.signInWithFacebook(presentingView: view){ user, error in
            if let user = user
            {
                self.loginWithSocialAccount(type: .google,name: user.fullName ?? user.fName, email: user.email, socialId: user.identifier, success: success, fail: fail)
            }
        }
        
    }
    
    private func loginWithSocialAccount(type: LoginTypes = .apple,name: String, email: String, socialId: String, success: @escaping ResponseCompletion, fail: @escaping ResponseCompletion)
    {
        let params = ["name": name, "email": email,"social_id": socialId,"type": type.rawValue]
        networkCall = NetworkCall(data: params, service: .login)
        networkCall.executeQuery { result in
            switch  result{
            case .success(let value):
                Logger.log(value)
                Superwall.shared.identify(userId: socialId)
                Superwall.shared.setUserAttributes(["fullName": name])
                if let response = value as? [String: Any]
                {
                    let statusCode = response["status"] as? Int ?? 0
                    let message = response["message"] as? String ?? ""
                    if statusCode == 200
                    {
                        let data = response["data"] as? [String: Any] ?? [:]
                        let user = data["user"] as? [String: Any] ?? [:]
                        let token = data["token"] as? String ?? ""
                        Utility.shared.saveCurrentUser(user)
                        Utility.shared.saveCurrentUserToken(token)
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
