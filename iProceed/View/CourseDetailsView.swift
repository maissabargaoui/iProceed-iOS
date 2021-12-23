//
//  CourseDetailsView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit

class CourseDetailsView: UIViewController {

    // variables
    var course: Course?
    
    // iboutlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var courseImage: UIImageView!
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCourseSegue" {
            let destination = segue.destination as! EditCourseView
            destination.course = course
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = course?.title
        descriptionTextView.text = course?.description
        
        ImageLoader.shared.loadImage(identifier: (course?.idPhoto)!, url: Constants.imagesUrl + (course?.idPhoto)!) { [self] image in
            courseImage.image = image
        }
    }
    
    // actions
    @IBAction func editCourse(_ sender: Any) {
        self.performSegue(withIdentifier: "editCourseSegue", sender: course)
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        UserViewModel().getUserFromToken() { [self] success, user in
            FavoriteViewModel().addFavorite(favorite: Favorite(date: Date(), user: user!, course: course!)) { success in
                if success {
                    let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                        navigationController?.popViewController(animated: true)
                    }
                    self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Added !", action: action), animated: true)
                } else {
                    self.present(Alert.makeAlert(titre: "Error", message: "Could add to favorites"), animated: true)
                }
            }
        }
    }
}
