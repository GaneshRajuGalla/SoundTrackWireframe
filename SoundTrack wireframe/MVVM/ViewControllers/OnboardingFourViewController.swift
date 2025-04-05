//
//  OnboardingFourViewController.swift
//  SoundTrack wireframe
//
//  Created by Adnan Bhatti on 22/03/2025.
//

import UIKit

class OnboardingFourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tryForFreePressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingFiveViewController") as! OnboardingFiveViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
