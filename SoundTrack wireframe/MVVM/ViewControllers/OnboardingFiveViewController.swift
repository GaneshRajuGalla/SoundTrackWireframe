//
//  OnboardingFiveViewController.swift
//  SoundTrack wireframe
//
//  Created by Adnan Bhatti on 22/03/2025.
//

import UIKit

class OnboardingFiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tryForFreePressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
