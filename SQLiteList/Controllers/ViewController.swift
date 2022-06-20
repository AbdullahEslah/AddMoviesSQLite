//
//  ViewController.swift
//  SQLiteList
//
//  Created by Macbook on 29/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MoviesCell", bundle: nil), forCellReuseIdentifier: "MoviesCell")
        tableView.dataSource = self
        tableView.delegate   = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ArrayManager.moviesData.removeAll()
        DBManager.shared.query()
        self.tableView.reloadData()
        
        print(ArrayManager.moviesData)
    }
    
    @IBAction func addMovieButtonClicked(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddMovieVC") as? AddMovieVC else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource ,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayManager.moviesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as? MoviesCell else {
            return UITableViewCell()
        }
        
        cell.movieName.text   = ArrayManager.moviesData[indexPath.row].movieName

        //load from document
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(ArrayManager.moviesData[indexPath.row].movieImage).path
       
        cell.movieImage.image = UIImage(contentsOfFile: path)
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    
    // Delete cell from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
            
               
               
               // Delete contact from database table
//               SQLiteCommands.deleteRow(contactId: contact.id)
            let movieName = ArrayManager.moviesData[indexPath.row].movieName
            
            DBManager.shared.delete(movie: movieName as NSString? ?? "")
            ArrayManager.moviesData.remove(at: indexPath.row)
//               self.loadData()
               self.tableView.reloadData()
           }
       }

}

