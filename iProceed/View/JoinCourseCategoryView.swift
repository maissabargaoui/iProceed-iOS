//
//  JoinCourseView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit
import SendBirdUIKit

class JoinCourseCategoryView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // variables
    var types : [String] = []
    var typeForDetails : String?
    var courses = [Course]()
    var courseForDetails: Course?
    
    // iboutlets
    @IBOutlet weak var coursesTableView: UITableView!
    
    // protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell", for: indexPath)
        let contentView = cell.contentView
        let titleLabel = contentView.viewWithTag(1) as! UILabel
        
        titleLabel.text = "Category : " + types[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        typeForDetails = types[indexPath.row]
        self.performSegue(withIdentifier: "coursesSegue", sender: typeForDetails)
    }
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coursesSegue" {
            let destination = segue.destination as! JoinCourseView
            destination.selectedType = typeForDetails
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCourses()
    }
    
    // methods
    func loadCourses() {
        CourseViewModel().getCourses { [self] succes, reponse in
            if succes {
                
                types = []
                types.append("All")
                
                for course in reponse! {
                    if !types.contains((course.user?.typeInstructeur)!) && (course.user?.typeInstructeur)! != "" {
                        types.append((course.user?.typeInstructeur)!)
                    }
                }
                
                self.coursesTableView.reloadData()
                
                UserViewModel().getUserFromToken { succes,userFromRep in
                    if succes {
                        var user = userFromRep
                        
                        if (user?.neverNotified)! {
                            user?.neverNotified = false
                            user?.coursNotifications = ["notifs"]
                        } else {
                            
                            var isPresenting = false
                            for course in self.courses {
                                
                                if !(user?.coursNotifications)!.contains(course._id!) {
                                    
                                    if !isPresenting {
                                        self.present(Alert.makeAlert(titre: "Notification", message: "Nouveaux cours ajoutées"), animated: true)
                                        isPresenting = true
                                    }
                                    
                                    user?.coursNotifications?.append(course._id!)
                                }
                            }
                        }
                        
                        UserViewModel().editNotifications(user: user!) { succes in }
                        
                    }
                }
            } else {
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
            SBUGlobals.CurrentUser = SBUUser(userId: "new user")
            
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
