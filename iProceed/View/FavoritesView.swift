//
//  FavoritesView.swift
//  iProceed
//
//  Created by Apple Mac on 8/12/2021.
//

import Foundation
import UIKit

class FavoritesView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // variables
    var favorites : [Favorite] = []
    var courseForDetails : Course?
    
    // iboutlets
    @IBOutlet weak var favoritesTableView: UITableView!
    
    // protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        let contentView = cell.contentView
        let titleLabel = contentView.viewWithTag(1) as! UILabel
        titleLabel.text = favorites[indexPath.row].course.title!
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            FavoriteViewModel().deleteFavorite(_id: favorites[indexPath.row]._id!) { success in
                if success {
                    self.favorites.remove(at: indexPath.row)
                    tableView.reloadData()
                } else {
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        courseForDetails = favorites[indexPath.row].course
        self.performSegue(withIdentifier: "courseDetailsSegue", sender: courseForDetails)
    }
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetailsSegue" {
            let destination = segue.destination as! CourseDetailsView
            destination.course = courseForDetails
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFavorites()
    }
    
    // methods
    func loadFavorites() {
        FavoriteViewModel().getFavorites { succes, reponse in
            if succes {
                for favorite in reponse!{
                    self.favorites = []
                    self.favorites.append(favorite)
                }
                self.favoritesTableView.reloadData()
            }
            else{
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load favorites"), animated: true)
            }
        }
    }
    
    var isEditingBool = false
    // actions
    @IBAction func editButton(_ sender: UIButton) {
        if isEditingBool {
            sender.setTitle("Edit", for: .normal)
            favoritesTableView.setEditing(false, animated: true)
        } else {
            sender.setTitle("Cancel", for: .normal)
            favoritesTableView.setEditing(true, animated: true)
        }
        isEditingBool = !isEditingBool
    }
}
