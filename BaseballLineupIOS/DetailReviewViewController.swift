//
//  DetailReviewViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-03.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class DetailReviewViewController: UIViewController {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var wholeCommentLabel: UILabel!
    @IBOutlet weak var ramenPicture: UIImageView!
    
    
    var review: AllReviewViewController.Review?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = review!.user
        evaluationLabel.text = String(review!.evaluation)
        wholeCommentLabel.text = review!.comment
        if let image = review?.picture {
            ramenPicture.image = image
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
