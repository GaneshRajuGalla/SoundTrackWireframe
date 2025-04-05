//
//  OnboardingOneViewController.swift
//  SoundTrack wireframe
//
//  Created by Adnan Bhatti on 21/03/2025.
//

import UIKit

class OnboardingOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func continuePressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingTwoViewController") as! OnboardingTwoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
}
