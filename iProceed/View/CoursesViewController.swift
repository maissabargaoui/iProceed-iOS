//
//  CoursesViewController.swift
//  iProceed
//
//  Created by mac on 29/11/2021.
//

import UIKit

class CoursesView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // variables
    var courses = [Course]()
    var courseForDetails : Course?
    
    // iboutlets
    @IBOutlet weak var coursesTableView: UITableView!
    
    
    // protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell", for: indexPath)
        let contentView = cell.contentView
        let titleLabel = contentView.viewWithTag(1) as! UILabel
        
        titleLabel.text = courses[indexPath.row].title!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        courseForDetails = courses[indexPath.row]
        self.performSegue(withIdentifier: "courseDetailSegue", sender: courseForDetails)
    }
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetailSegue" {
            let destination = segue.destination as! CourseDetailsView
            destination.course = courseForDetails
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCourses(tv: self.coursesTableView)
        coursesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coursesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coursesTableView.reloadData()
    }
    
    // methods
    func loadCourses(tv: UITableView) {
        CourseViewModel().getCourses { succes, reponse in
            if succes {
                for course in reponse!{
                    self.courses.append(course)
                }
                /*DispatchQueue.main.async {
                    self.coursesTableView.reloadWithAnimation()
                }*/
            }
            else{
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load courses"), animated: true)
            }
        }
    }
    
    // actions
    
}

