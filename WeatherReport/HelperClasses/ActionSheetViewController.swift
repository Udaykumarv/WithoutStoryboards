//
//  ActionSheetViewController.swift
//  WeatherReport
//
//  Created by Dilshad on 09/03/18.
//  Copyright © 2018 Dilshad. All rights reserved.
//

import UIKit

private let cellID = "cellIdentifier"

protocol ActionSheetViewControllerDelegate: class {
    func actionSheet(_ actionSheetVC: ActionSheetViewController, didSelectRowAt indexPathRow: Int)
}

class ActionSheetViewController: UIViewController {
    
    //Below property is used to set table view height, Default height percentage is 30
    private var tableViewHeightPercentage: CGFloat = 30 // 30 percentage of current screen height
    
    // Table view data source
    private var tableViewDataSource =  [String]()
    
    // Table view section header title, Default value "My Title"
    private var headerTitle = "My Title"
    
    // Table view section footer title, Default value "Cancel"
    private var footerTitle = "Cancel"
    
    private var dismissButton =  UIButton()
    
    weak var delegate: ActionSheetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.addSubViewsWithConstraints()
    }
    
    /**
     * Below method is used topresent action sheet
     *
     * @param atCurrentVC  Pass current controller reference
     * @param tableViewHeight To set tableview height
     * @param headerText To set tableview section header title
     * @param footerText To set tableview section footer title
     */
    class func showActionSheet(withDataSource dataSource: [String], atCurrentVC currentVC: UIViewController, tableViewHeight: CGFloat?, headerText: String?, footerText: String?) {
        
        let actionSheetVC = ActionSheetViewController()
        actionSheetVC.tableViewDataSource = dataSource
        actionSheetVC.modalPresentationStyle = .overCurrentContext
        actionSheetVC.tableViewHeightPercentage = tableViewHeight ?? 30
        actionSheetVC.headerTitle = headerText ?? "My Title"
        actionSheetVC.footerTitle = footerText ?? "Cancel"
        actionSheetVC.delegate = currentVC as? ActionSheetViewControllerDelegate
        currentVC.present(actionSheetVC, animated: true) {
//            actionSheetVC.fadeInAnimation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Helper methods -
extension ActionSheetViewController {

    /**
     * Below method is used to add tableview as subview.
     */
    private func addSubViewsWithConstraints() {
        
        // Creating TableView
        let listTableView: UITableView = {
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 30
            return tableView
        }()
        
        // Creating dismissButton
        dismissButton = {
            let button = UIButton(type: .custom)
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            button.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
            return button
        }()
        
        self.view.addSubview(listTableView)
        self.view.addSubview(dismissButton)
        
        // Adding Constarints
        let screenBounds = UIScreen.main.bounds
        let metricsDict = ["tableViewHeight": (screenBounds.height  * (tableViewHeightPercentage / 100))]
        
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", metricsDict: nil, views: listTableView)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", metricsDict: nil, views: dismissButton)
        self.view.addConstraintsWithFormat(format: "V:|[v0][v1(tableViewHeight)]|", metricsDict: metricsDict, views: dismissButton, listTableView)
    }
    
    /**
     * Below method is used at tableview header and footer section method
     */
    private func getTableViewHeaderOrFooterView(withTitle title: String) -> UIView {
        
        let sectionView: UIView = {
            let aView = UIView()
            aView.backgroundColor = UIColor.white
            
            let label = UILabel()
            label.text = title
            aView.addSubview(label)
            
            aView.addConstraintsWithFormat(format: "H:|-15-[v0]|", metricsDict: nil, views: label)
            aView.addConstraintsWithFormat(format: "V:|[v0]|", metricsDict: nil, views: label)
            return aView
        }()
        return sectionView
    }
    
    /**
     * Below method is used to dismiss action sheet
     */
    private func dismissActionSheet() {
        DispatchQueue.main.async {
//            self.dismissButton.alpha = 0.0
            self.dismiss(animated: true, completion: {
            })
        }
    }
    
    private func fadeInAnimation() {
        self.dismissButton.alpha = 0.0
        
        UIView.animate(withDuration: 0.1, animations: {
            self.dismissButton.alpha = 1.0
        })
    }
}

//MARK: - Button action methods -
extension ActionSheetViewController {
    
    /**
     * 
     */
    @objc func dismissButtonTapped() {
        dismissActionSheet()
    }
    
    /**
     * Below method is trigged when tableview section footer is tapped
     */
    @objc func cancelButtonTapped() {
        dismissActionSheet()
    }
}

//MARK: - TableView datasource and delegate methods -
extension ActionSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableViewDataSource.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) else {
                return UITableViewCell(style: .default, reuseIdentifier: cellID)
            }
            return cell
        }()
        
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = tableViewDataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getTableViewHeaderOrFooterView(withTitle: headerTitle)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = getTableViewHeaderOrFooterView(withTitle: footerTitle)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped))
        footerView.addGestureRecognizer(tapGesture)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.actionSheet(self, didSelectRowAt: indexPath.row)
        self.dismissActionSheet()
    }
}
