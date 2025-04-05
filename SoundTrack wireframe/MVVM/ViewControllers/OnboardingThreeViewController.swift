//
//  OnboardingThreeViewController.swift
//  SoundTrack wireframe
//
//  Created by Adnan Bhatti on 22/03/2025.
//

import UIKit

class OnboardingThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func continuePressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingFourViewController") as! OnboardingFourViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

   
}
