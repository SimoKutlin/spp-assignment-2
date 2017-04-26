//
//  ViewController.swift
//  AssignmentTwo
//
//  Created by Partenhauser Andreas on 10.02.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.requestPhotos(with: "Rosenheim") { (response, error) in
            if let photos = response?.objects {
                for photo in photos {
                    print(photo.identifier)
                }
            }
        }
    }
}

