//
//  OptionsTableViewController.swift
//  WheelyCool
//
//  Created by Huy Hoang Phi  on 13/3/2022.
//

import UIKit


class OptionsTableViewController: UIViewController {
    
    let tableView  = UITableView()
    let cellID = "OptionCell"
    
    var options: [Option] = [
        Option(text: "100$"),
        Option(text: "1000$"),
        Option(text: "250$"),
        Option(text: "125$"),
        Option(text: "10000$"),
        Option(text: "5000$"),
    ]
    
    var goToWheelButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Options"
        view.backgroundColor = .white
        configureTableView()
        // create add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        generateGotoWheelButton()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func generateGotoWheelButton() {
        goToWheelButton = UIButton(type: .system)
        guard let goToWheelButton = goToWheelButton else {
            return
        }
        view.addSubview(goToWheelButton)
        goToWheelButton.backgroundColor = .green
        goToWheelButton.translatesAutoresizingMaskIntoConstraints = false
        goToWheelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56).isActive = true
        goToWheelButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        goToWheelButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        goToWheelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goToWheelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToWheelVC)))
        goToWheelButton.layer.cornerRadius = 10
        goToWheelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        goToWheelButton.setTitle("Go to Wheel", for: .normal)
        goToWheelButton.titleLabel?.textColor = .black
    }
    
    @objc func goToWheelVC() {
        let wheelyViewController = WheelyViewController(slices: options.map({ option in
            String(option.text)
        }))
        navigationController?.pushViewController(wheelyViewController, animated: true)
    }
    
    @objc func addButtonTapped() {
        showAlertWithTextField(title: "Add New Option", message: "Please enter a new option", placeholder: "New Option") { [weak self] res in
            guard let self = self else { return }
            if (!res.isEmpty) {
                self.options.append(Option(text: res))
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: [IndexPath(row: self.options.count - 1, section: 0)], with: .automatic)}, completion: nil)
            }
        }
    }
    
    
}

//MARK: -- Table View Methods
extension OptionsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Deleted") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            if (self.options.count <= 2) {
                self.showAlert(title: "Cannot Delete", message: "Minimum number of options is 2")
                completion(true)
            } else {
                self.options.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                completion(true)
            }
        }
        delete.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = options[indexPath.row].text
        return cell
    }
    
}

//MARK: -- Utilities method
extension OptionsTableViewController {
    
    public func showAlertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("") })
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if let textFields = alert.textFields, let tf = textFields.first, let result = tf.text {
                completion(result)
            } else
            {
                completion("")
            }
        })
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        self.present(alert, animated: true)
    }
    
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
