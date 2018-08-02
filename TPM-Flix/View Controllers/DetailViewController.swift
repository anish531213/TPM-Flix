//
//  DetailViewController.swift
//  TPM-Flix
//
//  Created by Anish Adhikari on 7/26/18.
//  Copyright © 2018 Anish Adhikari. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var titleString: String = ""
    var releaseString: String = ""
    var descriptionString: String = ""
    var backDropPath: String = ""
    var posterPath: String = ""
    let baseUrlString: String = "https://image.tmdb.org/t/p/w500"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backDropUrl = URL(string: baseUrlString+backDropPath)
        let posterUrl = URL(string: baseUrlString+posterPath)
        
        backdropImageView.af_setImage(withURL: backDropUrl!)
        posterImageView.af_setImage(withURL: posterUrl!)
        
        titleLabel.text = titleString
        releaseLabel.text = releaseString
        descriptionLabel.text = descriptionString
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
