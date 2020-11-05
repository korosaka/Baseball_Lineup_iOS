//
//  AllReviewViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class AllReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Review {
        var user: String
        var evaluation: Int
        var comment: String
        var pictures: UIImage?
    }
    
    var selectedReview: Review?
    
    let reviews: [Review]
        = [Review(user: "Trump", evaluation: 4, comment: "My favorite shop, but is always crowded....JIjaRF0XffWxVPwwKwWeE9JuFbDejmWRcTbcYNYNFuaimcmthZSSy9hXmYlgefU6pCl4B9R8ZoBZuzlmnztOkysGWlnFKOUJxpoTpmplOgwzl85yuPTQtNc9BU0FSnsqdS5xeaTCDosWOOPjJwH4Ibh1YbZqbDCQ9beV4vFKgEvZWK6s5IXOskcoc56xOBi2fQXjA9gozZru9Q9Wr5OB7UUV6NkfjxwFSNIBJdeW91pMdPOOeUU5mF3BpLHv", pictures: UIImage(named: "ramen1")),
           Review(user: "Biden", evaluation: 5, comment: "Perfect!"),
           Review(user: "Trudeau", evaluation: 4, comment: "YbZqbDCQ9beV4vFKgEvZWK6s5IXOskcoc56xOBi2fQXjA9gozZru9Q9Wr5OB7UUV6NkfjxwFSNIBJdeW91pMdPOOeUU5mF3BpLHvrl1uiGySVB4Nxd0Ac84PuC6fDE2eUWEMAfMLI4lZbbg2xwtdPIvsF5I4pzhcj6bh4PKyyGFtCY09iaqUwUCZvEjkq4uZ843yC31WTVqRffOhgpa5AM2bvD2pq3AQ4fOMXaRSeJtgy7OMCfOjjnq5pkbKzrUBq9DpR2G2CRzBKWOpOq0PiaFGSYLht99PBZDhRUcBXE2ECY3t75bIr12ZR8ryuIvQZlGNbaARq5IuQ1IF", pictures: UIImage(named: "ramen2")),
           Review(user: "Obrador", evaluation: 4, comment: "4PKyyGFtCY09iaqUwUCZvEjkq4uZ843yC31WTVqRffOhgpa5AM2bvD2pq3AQ4fOMXaRSeJtgy7OMCfOjjnq5pkbKzrUBq9DpR2G2CRzBKWOpOq0PiaFGSYLht99PBZDhRUcBXE2ECY3t75bIr12ZR8ryuIvQZlGNbaARq5IuQ1IFMwa1tAJT1ZHDxQGzwrdW8k7MNBFlBBXgBKSmFAsWz7QLWfw2zgxmzJPxETDxSpWfdlqhAMd3DqunzXE"),
           Review(user: "Bolsonaro", evaluation: 3, comment: "ZoBZuzlmnztOkysGWlnFKOUJxpoTpmplOgwzl85yuPTQtNc9BU0FSnsqdS5xeaTCDosWOOPjJwH4Ibh1Yb", pictures: UIImage(named: "ramen3")),
           Review(user: "Duque", evaluation: 4, comment: "My favorite shop, but is always crowded"),
           Review(user: "Rouhani", evaluation: 4, comment: "My favorite shop, but is always crowded", pictures: UIImage(named: "ramen4")),
           Review(user: "Abe", evaluation: 4, comment: "P5mw66kGECqzMiPAevb2XxNi8u7Px27dUdO9N02L1SntLPI5OW5w5nRMA6tZdrfpNEECeHDPDCCjVVyGxNoOGrJ6Om3EPCyPNphCLF5GniJKvjpVX7heEjIsdW5oJGWAi1zkBI3yLHo7jvWhFkIVaTqIpXWexElUKoGDYywIPoOqQjiSTxi79nBBQ5KaBqHJ15KskJIjaRF0XffWxVPwwKwWeE9JuFbDejmWRcTbcYNYNFuaimcmthZSSy9hXmYlgefU6pCl4B9R8ZoBZuzlmnztOkysGWlnFKOUJxpoTpmplOgwzl85yuPTQtNc9BU0FSnsqdS5xeaTCDosWOOPjJwH4Ibh1YbZqbDCQ9beV4vFKgEvZWK6s5IXOskcoc56xOBi2fQXjA9gozZru9Q9Wr5OB7UUV6NkfjxwFSNIBJdeW91pMdPOOeUU5mF3BpLHvrl1uiGySVB4Nxd0Ac84PuC6fDE2eUWEMAfMLI4lZbbg2xwtdPIvsF5I4pzhcj6bh4PKyyGFtCY09iaqUwUCZvEjkq4uZ843yC31WTVqRffOhgpa5AM2bvD2pq3AQ4fOMXaRSeJtgy7OMCfOjjnq5pkbKzrUBq9DpR2G2CRzBKWOpOq0PiaFGSYLht99PBZDhRUcBXE2ECY3t75bIr12ZR8ryuIvQZlGNbaARq5IuQ1IFMwa1tAJT1ZHDxQGzwrdW8k7MNBFlBBXgBKSmFAsWz7QLWfw2zgxmzJPxETDxSpWfdlqhAMd3DqunzXEHCxXHsHR3QNve43kqgNq5BEN69qwTXYBsyKmiuFaNZKiuypAO2OjMdyvKKUcl7yVCqXOpGskI6SGzNPiyUKUrR2kr9bwiJmzHyoO2NgTuOROjrvTbwtzXjmnTYfxHXe6qwAMrgwQmefNmJWGjbWYPl0wFaoI8VPiQVCcgRIvy5nJz80OlWiKDLyegpUD0plZLxoyGH7EP5rkHE2d6PhWpxb1DHsgWC4KIj9vtHTQsbga", pictures: UIImage(named: "ramen5")),
           Review(user: "Suga", evaluation: 4, comment: "My favorite shop, but is always crowded", pictures: UIImage(named: "ramen6")),
           
           Review(user: "Obama", evaluation: 4, comment: "My favorite shop, but is always crowded"),
           Review(user: "Merkel", evaluation: 4, comment: "My favorite shop, but is always crowded"),
           Review(user: "Xi Jinping", evaluation: 4, comment: "My favorite shop, but is always crowded")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
            fatalError("Could not create ReviewCell")
        }
        reviewCell.userNameLabel.text = reviews[indexPath.row].user
        reviewCell.evaluationLabel.text = String(reviews[indexPath.row].evaluation)
        reviewCell.shortReviewLabel.text = reviews[indexPath.row].comment
        if let _ = reviews[indexPath.row].pictures {
            reviewCell.cameraIcon.image = UIImage(systemName: "camera.fill")
        } else {
            reviewCell.cameraIcon.image = UIImage(systemName: "camera")
        }
        
        return reviewCell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReview = reviews[indexPath.row]
        performSegue(withIdentifier: "goDetailView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewConntroller = segue.destination as? DetailReviewViewController {
            nextViewConntroller.review = selectedReview
        }
    }
    
}
