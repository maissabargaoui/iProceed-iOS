//
//  CoursesView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit
import SendBirdUIKit

class CoursesView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // variables
    var courses = [Course]()
    var courseForDetails : Course?
    var selectedType : String?
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        title = selectedType
        loadCourses(tv: self.coursesTableView)
    }
    
    // methods
    func loadCourses(tv: UITableView) {
        CourseViewModel().getCourses { [self] succes, reponse in
            if succes {
                
                courses = []
                
                if selectedType == "All" {
                    courses = reponse!
                } else {
                    for course in reponse! {
                        if selectedType == course.user?.typeInstructeur {
                            courses.append(course)
                        }
                    }
                }
                
                self.coursesTableView.reloadData()
            }
            else{
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load courses"), animated: true)
            }
        }
    }
    
    @IBAction func chatAction(_ sender: Any) {
        
        // 1. Initialize Sendbird UIKit
        SBUMain.initialize(applicationId: "9A063A9E-85CA-4214-B178-91D97859CC06") {
            
        } completionHandler: { error in
            
        }
        
        UserViewModel().getUserFromToken { [self] success, user in
            
            
            // 2. Set the current user
            SBUGlobals.CurrentUser = SBUUser(userId: (user?.name)!)

            // 3. Connect to Sendbird
            SBUMain.connect { (user, error) in
                
                // user object will be an instance of SBDUser
                guard let _ = user else {
                    print("ContentView: init: Sendbird connect: ERROR: \(String(describing: error)). Check applicationId")
                    return
                }
            }
            
            let clvc = SBUChannelListViewController()
            let navc = UINavigationController(rootViewController: clvc)
            navc.title = "Sendbird SwiftUI Demo"
            navc.modalPresentationStyle = .fullScreen
            present(navc, animated: true)
        }
    }
}
