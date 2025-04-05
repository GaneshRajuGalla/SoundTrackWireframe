//
//  GoogleSignInHandler.swift
//  sourmind
//
//  Created by Ajay Rajput on 21/12/22.
//

import Foundation
import GoogleSignIn

class GoogleSignInHandler
{
    let signInConfig = GIDConfiguration(clientID: Constants.googleAuthId)

    static let shared = GoogleSignInHandler()

    private init(){}

    private func restoreGoogleSignIn(completion: @escaping (SocialUser?, String?) -> ())
    {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            guard let signInUser = user else {
              // Inspect error
                Logger.log("Google Sigin Error ==> \(error?.localizedDescription ?? "")")
                completion(nil, error?.localizedDescription ?? "Google SignIn Error!")
              return
            }
            // If sign in succeeded, display the app's main content View.

            Logger.log(signInUser.userID ?? "")
            Logger.log(signInUser.profile?.email ?? "")

              var user =  SocialUser()
              user.email = signInUser.profile?.email ?? ""
              user.fName = signInUser.profile?.givenName ?? ""
              user.lName = signInUser.profile?.familyName ?? ""
              user.identifier = signInUser.userID ?? ""
              completion(user,nil)
          }
    }

    func handleSignInButton(presentingView: UIViewController,completion: @escaping (SocialUser?, String?) -> ())
    {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingView) { user, error in
                guard let signInUser = user else {
                    // Inspect error
                    Logger.log("Google Sigin Error ==> \(error?.localizedDescription ?? "")")
                    completion(nil, error?.localizedDescription ?? "Google SignIn Error!")
                    return
                }
                // If sign in succeeded, display the app's main content View.

                var user =  SocialUser()
                user.email = signInUser.user.profile?.email ?? ""
                user.fName = signInUser.user.profile?.givenName ?? ""
                user.lName = signInUser.user.profile?.familyName ?? ""
                user.identifier = signInUser.user.userID ?? ""
                completion(user,nil)
            }
    }


    func signOut()
    {
        GIDSignIn.sharedInstance.signOut()
    }

}
