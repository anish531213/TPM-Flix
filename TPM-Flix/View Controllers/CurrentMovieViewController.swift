//
//  CurrentMovieViewController.swift
//  TPM-Flix
//
//  Created by Anish Adhikari on 7/25/18.
//  Copyright © 2018 Anish Adhikari. All rights reserved.
//

import UIKit

class CurrentMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    var movies: [NSDictionary] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 161
        // Do any additional setup after loading the view.
        getMovies()
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getMovies()
    }
    
    func getMovies() {
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "Cannot get movies", message: "Sorry, cannot get your movies", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Reload", style: .cancel) { (action) in
                    self.getMovies()
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [NSDictionary]
//                print(self.movies)
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieTitle = movie["original_title"] as! String
        let movieDescription = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseUrlString: String = "https://image.tmdb.org/t/p/w500"
        let fullPosterPath = baseUrlString+posterPath
        let imageUrl = URL(string: fullPosterPath)
        cell.postImageView.af_setImage(withURL: imageUrl!)
        cell.titleLabel.text = movieTitle
        cell.descriptionLabel.text = movieDescription
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            
            let movieTitle = movie["original_title"] as! String
            let movieDescription = movie["overview"] as! String
            let posterPath = movie["poster_path"] as! String
            let backdropPath = movie["backdrop_path"] as! String
            let releaseDate = movie["release_date"] as! String
            
            detailViewController.titleString = movieTitle
            detailViewController.descriptionString = movieDescription
            detailViewController.releaseString = releaseDate
            detailViewController.posterPath = posterPath
            detailViewController.backDropPath = backdropPath
                 
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
