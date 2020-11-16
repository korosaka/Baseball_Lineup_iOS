//
//  ReviewData.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-15.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import UIKit

struct Review {
    var user: String
    var evaluation: Int
    var comment: String
    var picture: UIImage?
}

class ReviewData {
    var reviews: [Review]
    var delegate: ReviewDataDelegate?
    
    init() {
        self.reviews = originalReviewData
    }
    
    func countReview() -> Int {
        return reviews.count
    }
    
    // MARK: add new review
    func reloadReviewData() {
        
        // guruguru?
        
        let globalQueue = DispatchQueue.global(
            qos: DispatchQoS.QoSClass.userInitiated)
        globalQueue.async { [ weak self] in
            let newReview = Review(user: "NewUser", evaluation: 5, comment: "New review was added !", picture: nil)
            // MARK: to show indicator
            Thread.sleep(forTimeInterval: 2.0)
            
            DispatchQueue.main.async {
                self!.reviews.append(newReview)
                self!.delegate?.afterReload()
            }
        }
    }
    
    
    var originalReviewData: [Review]
        = [Review(user: "Trump", evaluation: 4, comment: "My favorite shop, but is always crowded....JIjaRF0XffWxVPwwKwWeE9JuFbDejmWRcTbcYNYNFuaimcmthZSSy9hXmYlgefU6pCl4B9R8ZoBZuzlmnztOkysGWlnFKOUJxpoTpmplOgwzl85yuPTQtNc9BU0FSnsqdS5xeaTCDosWOOPjJwH4Ibh1YbZqbDCQ9beV4vFKgEvZWK6s5IXOskcoc56xOBi2fQXjA9gozZru9Q9Wr5OB7UUV6NkfjxwFSNIBJdeW91pMdPOOeUU5mF3BpLHv", picture: UIImage(named: "ramen1")),
           Review(user: "Biden", evaluation: 5, comment: "Perfect!"),
           Review(user: "Trudeau", evaluation: 4, comment: "YbZqbDCQ9beV4vFKgEvZWK6s5IXOskcoc56xOBi2fQXjA9gozZru9Q9Wr5OB7UUV6NkfjxwFSNIBJdeW91pMdPOOeUU5mF3BpLHvrl1uiGySVB4Nxd0Ac84PuC6fDE2eUWEMAfMLI4lZbbg2xwtdPIvsF5I4pzhcj6bh4PKyyGFtCY09iaqUwUCZvEjkq4uZ843yC31WTVqRffOhgpa5AM2bvD2pq3AQ4fOMXaRSeJtgy7OMCfOjjnq5pkbKzrUBq9DpR2G2CRzBKWOpOq0PiaFGSYLht99PBZDhRUcBXE2ECY3t75bIr12ZR8ryuIvQZlGNbaARq5IuQ1IF", picture: UIImage(named: "ramen2")),
           Review(user: "Obrador", evaluation: 4, comment: "4PKyyGFtCY09iaqUwUCZvEjkq4uZ843yC31WTVqRffOhgpa5AM2bvD2pq3AQ4fOMXaRSeJtgy7OMCfOjjnq5pkbKzrUBq9DpR2G2CRzBKWOpOq0PiaFGSYLht99PBZDhRUcBXE2ECY3t75bIr12ZR8ryuIvQZlGNbaARq5IuQ1IFMwa1tAJT1ZHDxQGzwrdW8k7MNBFlBBXgBKSmFAsWz7QLWfw2zgxmzJPxETDxSpWfdlqhAMd3DqunzXE"),
           Review(user: "Bolsonaro", evaluation: 3, comment: "ZoBZuzlmnztOkysGWlnFKOUJxpoTpmplOgwzl85yuPTQtNc9BU0FSnsqdS5xeaTCDosWOOPjJwH4Ibh1Yb", picture: UIImage(named: "ramen3")),
           Review(user: "Duque", evaluation: 4, comment: "My favorite shop, but is always crowded"),
           Review(user: "Rouhani", evaluation: 4, comment: "My favorite shop, but is always crowded", picture: UIImage(named: "ramen4")),
           Review(user: "Abe", evaluation: 4, comment: "P5mw66kGECqzMiPAevb2XxNi8u7Px27dUdO9N02L1SntLPI5OW5w5nRMA6tZdrfpNEECeHDPDCCjVVyGxNoOGrJ6Om3EPCyPNphCLF5GniJKvjpVX7heEjIsdW5oJGWAi1zkBI3yLHo7jvWhFkIVaTqIpXWexElUKoGDYywIPoOqQjiSTxi79nBBQ5KaBqHJ15KskJIjaRF0XffWxVPwwKwWeE9JuFbDejmWRcTbcYNYNFuaimcmthZSSy9hXmYlgefU6pCl4B9R8ZoBZuzlmnztOkysGWlnFKOUJxpoTpmplOgwzl85yuPTQtNc9BU0FSnsqdS5xeaTCDosWOOPjJwH4Ibh1YbZqbDCQ9beV4vFKgEvZWK6s5IXOskcoc56xOBi2fQXjA9gozZru9Q9Wr5OB7UUV6NkfjxwFSNIBJdeW91pMdPOOeUU5mF3BpLHvrl1uiGySVB4Nxd0Ac84PuC6fDE2eUWEMAfMLI4lZbbg2xwtdPIvsF5I4pzhcj6bh4PKyyGFtCY09iaqUwUCZvEjkq4uZ843yC31WTVqRffOhgpa5AM2bvD2pq3AQ4fOMXaRSeJtgy7OMCfOjjnq5pkbKzrUBq9DpR2G2CRzBKWOpOq0PiaFGSYLht99PBZDhRUcBXE2ECY3t75bIr12ZR8ryuIvQZlGNbaARq5IuQ1IFMwa1tAJT1ZHDxQGzwrdW8k7MNBFlBBXgBKSmFAsWz7QLWfw2zgxmzJPxETDxSpWfdlqhAMd3DqunzXEHCxXHsHR3QNve43kqgNq5BEN69qwTXYBsyKmiuFaNZKiuypAO2OjMdyvKKUcl7yVCqXOpGskI6SGzNPiyUKUrR2kr9bwiJmzHyoO2NgTuOROjrvTbwtzXjmnTYfxHXe6qwAMrgwQmefNmJWGjbWYPl0wFaoI8VPiQVCcgRIvy5nJz80OlWiKDLyegpUD0plZLxoyGH7EP5rkHE2d6PhWpxb1DHsgWC4KIj9vtHTQsbga", picture: UIImage(named: "ramen5")),
           Review(user: "Suga", evaluation: 4, comment: "My favorite shop, but is always crowded", picture: UIImage(named: "ramen6")),
           
           Review(user: "Obama", evaluation: 4, comment: "My favorite shop, but is always crowded"),
           Review(user: "Merkel", evaluation: 4, comment: "My favorite shop, but is always crowded"),
           Review(user: "Xi Jinping", evaluation: 4, comment: "My favorite shop, but is always crowded")]
}


// MARK: from Model to ViewModel
protocol ReviewDataDelegate {
    func afterReload()
}
