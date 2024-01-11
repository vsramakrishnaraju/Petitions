//
//  ViewController.swift
//  Project7
//
//  Created by Venkata K on 1/5/24.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var mainData = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(openTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterList))
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Data comes from We the People API of the White House", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func filterList() {
        let ac = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        if answer == "" {
            petitions = mainData
            tableView.reloadData()
        } else {
            petitions = petitions.filter { $0.title.contains(answer) ||  $0.body.contains(answer) }
            tableView.reloadData()
            petitions = mainData
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was error loading the feed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
            mainData = jsonPetitions.results
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        vc.heading = petitions[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

