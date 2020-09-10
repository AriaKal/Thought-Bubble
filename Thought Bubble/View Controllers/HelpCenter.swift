//
//  HelpCenter.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 4/10/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit

class HelpCenter: UIViewController {
    
    private var faqTableView: UITableView!
    private let cellID = "cellID"
    private var faqs: [FAQs] = []
    
    let FAQsQuestions = ["How can I reset my password?",
                         "Who has access to my data?",
                         "Can I know who posted what?",
                         "How can I edit my profile?",
                         "Are other users able to know what I voted on?",
                         "Can I revote?",
                         "Is my password protected?",
                         "How are claims analyzed in statistics?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styling of the view
        view.backgroundColor = .white
        
        // Title
        self.navigationItem.title = "FAQs";
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        setData()
        createTableView()
    }
}

extension HelpCenter {
    fileprivate func setData() {
        faqs = [
            FAQs(ishidden: true, faq: [FAQ(answer: "Once logged in, visit your profile page, which will display all of your personal information. Choose, the password field, edit it and save the changes.")]),
            FAQs(ishidden: true, faq: [FAQ(answer: "Thought Bubble values user data privacy. User data will only be used to enhance the user experience and thus, no third party companies will access to it.")]),
            FAQs(ishidden: true, faq: [FAQ(answer: "To preserve integrity and objectivity, Thought Bubble doesn't publicly display the idenities of the users who posted each post. However, you can view a list of all the posts that you've posted in the 'My Claims' section, which you can find from the side-menu.")]),
            FAQs(ishidden: true, faq: [FAQ(answer: "Just visit the 'My Profile' section of the application. There you will be presented with all information saved regarding your user profile. Click on any field, edit it and then save the changes. You're done!")]),
            FAQs(ishidden: true, faq: [FAQ(answer: "No, your votes are completely anonymous for the purpose of collecting genuine real opinions and consequently producing reliable statistical data.")]),
            FAQs(ishidden: true, faq: [FAQ(answer: "The short answer is no. To elaborate, just like any other voting system, you get a one time chance to vote. This is mainly for the purposes of valuing each and every vote. Also, changing your votes all the time would lead you to take the platform and the discussions less seriously.")]),
            FAQs(ishidden: true, faq: [FAQ(answer: "Passwords are encrypted then saved in the database in that format. Therefore, not even employees who have access to the Thought Bubble database can view users' passwords.")]),
            FAQs(ishidden: true, faq: [FAQ(answer: "'Mostly Agreed' claims are ones that have over 75% of votes = agreed. 'Mostly Disagreed' claims are ones that have over 75% of votes = disagreed. 'Controversial' claims are ones that do not have a clear majority pick i.e larger percentage - smaller percentage < 50.")]),
        ]
    }
}

extension HelpCenter {
    fileprivate func createTableView() {
        faqTableView = UITableView(frame: .zero, style: .grouped)
        faqTableView.translatesAutoresizingMaskIntoConstraints = false
        faqTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        faqTableView.dataSource = self
        faqTableView.delegate = self
        faqTableView.rowHeight = 200
        view.addSubview(faqTableView)
        
        let faqTableViewConstraints = [faqTableView.leftAnchor.constraint(equalTo: view.leftAnchor), faqTableView.topAnchor.constraint(equalTo: view.topAnchor), faqTableView.rightAnchor.constraint(equalTo: view.rightAnchor), faqTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        
        NSLayoutConstraint.activate(faqTableViewConstraints)
    }
}

extension HelpCenter: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ishidden = faqs[section].ishidden
        if ishidden {
            return 0
        }
        return faqs[section].faq.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = faqs[indexPath.section].faq[indexPath.row].answer
        cell?.textLabel?.textColor = Colors.darkBlue
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }
}

extension HelpCenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // View Design
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        view.backgroundColor = Colors.darkBlue.withAlphaComponent(0.90)
        
        // Question button to expand & display answers
        let button = UIButton(frame: CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width, height: 65))
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(FAQsQuestions[section], for: .normal)
        button.tag = section
        button.addTarget(self, action: #selector(collapse(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        return view
    }
}

extension HelpCenter {
    @objc fileprivate func collapse(_ sender: UIButton) {
        var selectedFAQ = faqs[sender.tag]
        selectedFAQ.ishidden = !selectedFAQ.ishidden
        faqs[sender.tag] = selectedFAQ
        faqTableView.reloadData()
    }
}
