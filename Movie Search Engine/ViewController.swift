//
//  ViewController.swift
//  Movie Search Engine
//
//  Created by Deekshitha Thumma on 5/17/18.
//  Copyright © 2018 Deekshitha Thumma. All rights reserved.
//
// Resources used: some external resurces used for GET request syntax
//
// What I would implement if I was to publish this to the AppStore:
//  - Add a Startup screen
//  - Display more information than just the title, overview, and poster
//  - Make the cells selectable and direct to a screen with all the details of the seclected movie
//  - The ablity to star or heart your favorite movies and be able to view a list of those
//  - Make the speed of the images (posters) diplaying in the table faster
//  - Make the UI less bland, add more slight color
//  - Add App Icon
//  - Launch a beta release first

import UIKit

//Custom Table View Cell
class MovieTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!

}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //Iniialize data array for tableview
    var movies = [["Title"],
                  ["Overview"],
                  ["default"]]
    
    let cellReuseIdentifier = "cell"

    
    @IBOutlet weak var MoviesTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set textfield
        self.searchTextField.delegate = self
        
        //set tableview
        MoviesTableView.delegate = self
        MoviesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function: Number of rows in movie table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies[0].count
    }
    
    //Function: Create a cell for each row and set the title, overview, and image
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a cell
        let cell:MovieTableViewCell = self.MoviesTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MovieTableViewCell
            
        // set the text from the data model (Movies array)
        cell.titleLabel?.text = self.movies[0][indexPath.row]
        cell.overviewLabel?.text = self.movies[1][indexPath.row]
        
        //Set image to default for now to avoid flickering
        cell.posterImage?.image = UIImage(named: "Default")
        
        //If the movie has no poster, set image to default image
        if(self.movies[2][indexPath.row] == "default")
        {
            cell.posterImage?.image = UIImage(named: "Default")
        }
        //Get poster
        else
        {
            //download image from url for the poster and set as cell's image
            let url = URL(string:"https://image.tmdb.org/t/p/w600_and_h900_bestv2" + self.movies[2][indexPath.row])
            
            let session = URLSession(configuration: .default)
            
            //creating a dataTask
            let task = session.dataTask(with: url!) { (data, response, error) in
                
                if let e = error {
                    print("Error Occurred: \(e)")
                    
                } else {
                    //check for the response
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            
                            //get image
                            let image = UIImage(data: imageData)
                            
                            //set cell image to the downloaded image
                            DispatchQueue.main.async {
                                cell.posterImage?.image = image
                            }
                            
                        } else {
                            print("Error getting poster")
                        }
                    } else {
                        print("Error getting poster")
                    }
                }
            }
            task.resume()
        }
        
        return cell

    }

    
    //Function: when user finishes search term, call our search function and display results
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        searchAPI(term: textField.text!)
        return true
    }

    //Function: Get request to Movies DB and populate data model (Movies array)
    func searchAPI(term: String)
    {
        //temporary arrays
        var titles: [String] = []
        var overviews: [String] = []
        var images: [String] = []
        
        //get URL and replace spaces with "+"
        let fixedTerm = term.replacingOccurrences(of: " ", with: "+")
        let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query=" + fixedTerm)!
        
        let urlSession = URLSession.shared
        let getRequest = URLRequest(url:url)
        
        //creating a dataTask
        let task = urlSession.dataTask(with: getRequest as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }

            
            // parse JSON
            do {
                guard let requestResults = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        print("Error trying to convert data to JSON")
                        return
                }
                
                //get "results" array from JSON dict
                guard let requestMovies = requestResults["results"] as? [[String:Any]] else {
                    print("Error getting array of movies")
                    return
                }
                
                //For each element in array, store title overview and image
                for movie in requestMovies
                {
                    let title = movie["title"] as? String
                    titles.append(title!)
                    
                    let overview = movie["overview"] as? String
                    overviews.append(overview!)
                    

                    if let poster = movie["poster_path"] as? String {
                       images.append(poster)
                    }
                    else{
                        images.append("default")
                    }
                    
                }
                
                //Set this new data into our data model
                self.movies[0] = titles
                self.movies[1] = overviews
                self.movies[2] = images
                
                //Reload the table to display updated data model
                DispatchQueue.main.async {
                    self.MoviesTableView.reloadData()
                }
                
            } catch  {
                print("Error trying to convert data to JSON")
                return
            }
        })
        task.resume()
    }
}

