//
//  OnboardingViewController.swift
//  weather
//
//  Created by User on 2/18/18.
//  Copyright © 2018 dikan.chen. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var zipcode: UITextField!
    
    @IBAction func continueTouched(_ sender: UIButton) {
        UserDefaults.standard.set(zipcode.text, forKey: "zipcode")
        performSegue(withIdentifier: "segue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
