//
//  SuperheroViewController.swift
//  TPM-Flix
//
//  Created by Anish Adhikari on 8/1/18.
//  Copyright © 2018 Anish Adhikari. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getMovies()
    }
    
    func getMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/284054/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.collectionView.reloadData()
            }
            
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = self.movies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let posterPath = movie["poster_path"] as! String
        let baseUrlString: String = "https://image.tmdb.org/t/p/w500"
        let fullPosterPath = baseUrlString+posterPath
        let imageUrl = URL(string: fullPosterPath)
        cell.posterImageView.af_setImage(withURL: imageUrl!)
        
        return cell
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
