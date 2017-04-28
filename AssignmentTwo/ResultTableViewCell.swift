//
//  TableViewCell.swift
//  AssignmentTwo
//
//  Created by admin on 26.04.17.
//  Copyright © 2017 BestCheck. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureTitle: UILabel!
    
    var photoData: Photo? { didSet { updateUI() } }
    
    
    private func updateUI() {
        pictureTitle?.text = photoData?.title
    }
    
}
