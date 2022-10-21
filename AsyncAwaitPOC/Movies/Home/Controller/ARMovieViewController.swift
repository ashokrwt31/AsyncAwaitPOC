//
//  ARMovieViewController.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 02/10/22.
//

import UIKit

class ARMovieViewController: UIViewController {
    @IBOutlet weak var movieTableView: UITableView!
    
    var movies: [ARMovie] = [] {
        didSet {
            if ARAPI.isAsyncType {
                movieTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movies"
        
        self.movieTableView.register(UINib(nibName: "ARMovieCell", bundle: .main), forCellReuseIdentifier: "ARMovieCell")
        
        // Execute code based on isAsyncType Condition
        if ARAPI.isAsyncType {
            apiCallUsingAsyncAwait()
        } else {
            apiCallUsingClosure()
        }
    }
}

extension ARMovieViewController {
    
    // MARK: - Using Async Await
    
    private func apiCallUsingAsyncAwait() {
        Task {
            let result = try? await ARMoviesViewModel().callMoviesAPIAsyncAwait(ARMovieResponse.self)
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let items): movies = items.results
            case .none: print("None")
            }
            print("Inside the Task")
        }
        print("After the Task")
    }
}


extension ARMovieViewController {
    // MARK: - Using Closure
    
    private func apiCallUsingClosure() {
        ARMoviesViewModel().callMoviesAPI { [weak self] result, error in
            if error == nil, let moviesResult = result  {
                self?.movies = moviesResult.results
                DispatchQueue.main.async {
                    self?.movieTableView.reloadData()
                }
            }
        }
    }
}


// MARK: - TableView Data Source

extension ARMovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = movieTableView.dequeueReusableCell(withIdentifier: "ARMovieCell", for: indexPath) as? ARMovieCell {
            cell.cellConfiguration(movie: movies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate

extension ARMovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ARMovieDetailVC") as! ARMovieDetailVC
        vc.movie = movies[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


















/*
 //                if let moviesResults = try? await ARMoviesViewModel().callFlickrPhotoAPIAsyncAwait(ARMovieResponse.self)?.get().results {
 //                    movies = moviesResults
 //                }
 //                else {
 //                    print("Not found")
 //                }
 */
