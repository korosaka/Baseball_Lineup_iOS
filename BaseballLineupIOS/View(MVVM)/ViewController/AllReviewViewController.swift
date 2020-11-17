//
//  AllReviewViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class AllReviewViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBAction func onClickReload(_ sender: Any) {
        indicator.startAnimating()
        viewModel?.reloadData()
    }
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: AllReviewViewModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    func setup() {
        viewModel = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        indicator.stopAnimating()
    }
}

extension AllReviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count: Int = viewModel?.getReviewCount() {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
            fatalError("Could not create ReviewCell")
        }
        reviewCell.userNameLabel.text = viewModel?.getUserName(index: indexPath.row)
        reviewCell.evaluationLabel.text = viewModel?.getEvaluation(index: indexPath.row)
        reviewCell.shortReviewLabel.text = viewModel?.getComment(index: indexPath.row)
        reviewCell.cameraIcon.image = viewModel?.getIcon(index: indexPath.row)
        
        return reviewCell
    }
}

extension AllReviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectReview(index: indexPath.row)
        performSegue(withIdentifier: "goDetailView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewConntroller = segue.destination as? DetailReviewViewController {
            nextViewConntroller.review = viewModel?.selectedReview
        }
    }
}

extension AllReviewViewController: AllReviewViewModelDelegate {
    func tableviewRefresh() {
        tableView.reloadData()
        indicator.stopAnimating()
    }
}
