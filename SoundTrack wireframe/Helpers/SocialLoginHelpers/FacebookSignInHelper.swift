//
//  FacebookSignInHelper.swift
//  gloouel
//
//  Created by Ajay Rajput on 06/09/22.
//

import Foundation
import FacebookCore
import FacebookLogin


class FacebookSignInHelper
{
    static let shared = FacebookSignInHelper()
    let manager = LoginManager()

    private init(){}

    func signInWithFacebook(presentingView: UIViewController,completion: @escaping (SocialUser?, String?) -> ())
    {

        self.signOut()

        if let token = AccessToken.current{
            self.getDataWithGraphRequest(token: token.tokenString){ (result, error) in
                if let user = result{
                    completion(user,nil)
                }else{
                    completion(nil,error ?? "")
                }
            }
        }else{
//            self.manager.permiss
            self.manager.logIn(permissions: ["public_profile","email"], from: presentingView){ (result, error) in

                if let error = error {
                    print(error.localizedDescription)
                    completion(nil,error.localizedDescription)
                } else if result?.isCancelled ?? false {
                    // dismiss view
                    completion(nil,nil)
                } else {
                    // do something with the token
                    self.getDataWithGraphRequest(token: AccessToken.current?.tokenString ?? ""){ (result, error) in
                        if let user = result{
                            completion(user,nil)
                        }else{
                            completion(nil,error ?? "")
                        }
                    }
                }
            }
        }
    }

    func signOut()
    {
        self.manager.logOut()
    }


    private func getDataWithGraphRequest(token: String,completion: @escaping (SocialUser?, String?) -> ())
    {
        let params = ["fields": "id,first_name,last_name,email"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params, tokenString: AccessToken.current?.tokenString ?? "", version: nil, httpMethod: .get)
        graphRequest.start { (connection, result, error) in

            if let err = error {
                Logger.log("Facebook graph request error: \(err)")
                completion(nil,err.localizedDescription)

            } else {
                Logger.log("Facebook graph request successful!")

                guard let json = result as? NSDictionary else { return }

                let email = json["email"] as? String ?? ""
                Logger.log("\(email)")

                let firstName = json["first_name"] as? String ?? ""
                Logger.log("\(firstName)")

                let lastName = json["last_name"] as? String ?? ""
                Logger.log("\(lastName)")

                let id = json["id"] as? String ?? ""
                Logger.log("\(id)")

                var user =  SocialUser()
                user.email = email
                user.fName = firstName
                user.lName = lastName
                user.identifier = id
                completion(user,nil)
            }
        }
    }

}
