//
//  ARMovieDetailVC.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 04/10/22.
//

import UIKit

enum CellType: String, CaseIterable {
    case Cast
    case Review
}

class ARMovieDetailVC: UIViewController {
    
    @IBOutlet weak var detailTableVIew: UITableView!
    
    var data: (credits: [ARMovieCast],
               reviews: [ARReview]) = ([], [])
    //    var data = [AnyObject]() {
    //        didSet {
    //            if ARAPI.isAsyncType {
    //                detailTableVIew.reloadData()
    //            }
    //        }
    //    }
    
    var movie: ARMovie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.detailTableVIew.register(UINib(nibName: "ARMovieCastCell", bundle: .main), forCellReuseIdentifier: "ARMovieCastCell")
        self.detailTableVIew.register(UINib(nibName: "ARMovieReviewCell", bundle: .main), forCellReuseIdentifier: "ARMovieReviewCell")
        
        Task {
            
            let creditResult = try? await ARMovieDetailViewModel().callMoviesCastAPIAsyncAwait(ARMovieCredit.self, self.movie)
            switch creditResult {
            case .failure(let error): print(error.localizedDescription)
            case .success(let items): data.credits = items.cast
            case .none: print("None")
            }
            
            self.detailTableVIew.reloadData()
        }
        Task {
            let reviewResult = try? await ARMovieDetailViewModel().callMoviesReviewsAPIAsyncAwait(ARMovieReview.self, self.movie)
            switch reviewResult {
            case .failure(let error): print(error.localizedDescription)
            case .success(let items): data.reviews = items.results
            case .none: print("None")
            }
            
            self.detailTableVIew.reloadData()
        }
    }
}

// MARK: - TableView Data Source

extension ARMovieDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
           case 0: return data.credits.count
           case 1: return data.reviews.count
           default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let cell = detailTableVIew.dequeueReusableCell(withIdentifier: "ARMovieCastCell", for: indexPath) as? ARMovieCastCell {
                cell.creditCellConfiguration(cast: data.credits[indexPath.row])
                return cell
            }
        }
        else {
            if let cell = detailTableVIew.dequeueReusableCell(withIdentifier: "ARMovieReviewCell", for: indexPath) as? ARMovieReviewCell {
                cell.reviewCellConfiguration(review: data.reviews[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate

extension ARMovieDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getTitleForHeader(section).0
    }
    
    func getTitleForHeader(_ section: Int) -> (String?, String?) {
        switch section {
           case 0: return ("Cast and Crew", "person-cast")
           case 1: return ("Reviews (\(data.reviews.count))" , "Rreviews")
           default: return ("", "")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionHeaderLabelView = UIView()
            sectionHeaderLabelView.backgroundColor = .lightGray

            let sectionHeaderImage = UIImage(named: self.getTitleForHeader(section).1 ?? "")
            let sectionHeaderImageView = UIImageView(image: sectionHeaderImage)
            sectionHeaderImageView.frame = CGRect(x: 13, y: 10, width: 30, height: 30)
            sectionHeaderLabelView.addSubview(sectionHeaderImageView)

            let sectionHeaderLabel = UILabel()
            sectionHeaderLabel.text = getTitleForHeader(section).0
            sectionHeaderLabel.textColor = .white
            sectionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            sectionHeaderLabel.frame = CGRect(x: 56, y: 5, width: 250, height: 40)
            sectionHeaderLabelView.addSubview(sectionHeaderLabel)
            return sectionHeaderLabelView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


