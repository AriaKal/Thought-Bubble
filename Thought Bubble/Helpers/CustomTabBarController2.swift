//
//  CustomTabBarController2.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 5/19/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class CustomTabBarController2: UITabBarController {
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid // uid of currently logged in user
    let searchBar = UISearchBar()
    var menuShowing = false
    var sideMenuWidth: NSLayoutConstraint?
    let cellID = "cellID"
    var menuItemsArray = ["", "My Claims", "My Profile", "Help Center", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavBarItems()
    }
    
    func setUpNavBarItems() {
        displayUsername()
        showMenuButton()
        searchBar.sizeToFit()
        searchBar.delegate = self as! UISearchBarDelegate
        showSearchBarButton(true)
    }
    
    func displayUsername() {
        var username = ""
        db.collection("users").whereField("uid", isEqualTo: uid)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting username: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    username = document.data()["username"] as? String ?? ""
                    self.menuItemsArray[0] = username
                }
            }
        }
    }
    
    func showMenuButton() {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.addTarget(self, action:#selector(menuButtonTapped), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = menuBarItem
        
        view.addSubview(sideMenu)
        sideMenuWidth = sideMenu.widthAnchor.constraint(equalToConstant: 0)
        sideMenuWidth?.isActive = true
        
        NSLayoutConstraint.activate([
            sideMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sideMenu.leftAnchor.constraint(equalTo: view.leftAnchor),
            sideMenu.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        sideMenu.delegate = self
        sideMenu.dataSource = self
    }
    
    lazy var sideMenu: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.backgroundColor = Colors.lightBlue.withAlphaComponent(0.5)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // Search icon - clickable button
    func showSearchBarButton(_ shouldShow:Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarTapped))
            
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // Whole typable search bar
    func search(_ shouldShow: Bool) {
        showSearchBarButton(!shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    // Tapping the search bar
    @objc func searchBarTapped() {
        search(true)
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "Search Thought Bubble"
    
        // Colors
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.tintColor = Colors.darkBlue
        searchBar.searchTextField.textColor = Colors.darkBlue
        searchBar.searchTextField.autocapitalizationType = .none
    }
    
    // Tapping on the menu button
    @objc func menuButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuWidth?.isActive = false
            
            if(self.menuShowing) {
                self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
            } else {
                self.view.bringSubviewToFront(self.sideMenu)
                self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 350)
            }
            
            self.sideMenuWidth?.isActive = true
            self.view.layoutIfNeeded()
        })
        menuShowing = !menuShowing
    }
}

extension CustomViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(false)
    }
}

extension CustomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenu.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as UITableViewCell
        let menuItems = menuItemsArray[indexPath.row]
        
        // Customize the look of the cells
        cell.backgroundColor = Colors.darkBlue.withAlphaComponent(0)
        cell.textLabel?.text = menuItems
        cell.textLabel?.textColor = .white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = Colors.darkBlue.withAlphaComponent(0.75)
        cell.selectedBackgroundView = myCustomSelectionColorView
        
        // Customize first row different from rest
        switch (indexPath.section, indexPath.row) {
          case (0, 0):
            cell.textLabel?.font = UIFont.systemFont(ofSize: 40)
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            
            let separator = UILabel(frame: CGRect(x: 15, y: cell.frame.size.height * 2, width: cell.frame.size.width, height: 1))
            separator.backgroundColor = .white
            cell.contentView.addSubview(separator)
            
          default:
            cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
          }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firebaseAuth = Auth.auth()
        
        if(indexPath.row == 4) { // Logout
            do {
                try firebaseAuth.signOut()

                // Go back to login-signup view
                let launchViewController = storyboard?.instantiateViewController(identifier: "launchView")
                
                // Animate transition
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.15
                view.window?.layer.add(transition, forKey: kCATransition)
                view.window?.rootViewController = launchViewController
                view.window?.makeKeyAndVisible()
    
            } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
            }
        } else if (indexPath.row == 3) { // Help Center
            let helpCenter = HelpCenter()
            navigationController?.pushViewController(helpCenter, animated: false)
        } else if (indexPath.row == 2) { // User Profile
            let userProfile = UserProfile()
            navigationController?.pushViewController(userProfile, animated: false)
        } else if (indexPath.row == 1) { // My Claims
            let myClaims = MyClaims()
            navigationController?.pushViewController(myClaims, animated: false)
        }
    }
}
