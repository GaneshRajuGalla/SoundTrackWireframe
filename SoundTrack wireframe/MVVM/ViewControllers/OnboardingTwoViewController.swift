//
//  OnboardingTwoViewController.swift
//  SoundTrack wireframe
//
//  Created by Adnan Bhatti on 21/03/2025.
//

import UIKit

class OnboardingTwoViewController: UIViewController {

    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
    // Actions
    
    
    @IBAction func continuePressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingThreeViewController") as! OnboardingThreeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
   
   
    
    

}
