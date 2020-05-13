//
//  ContentView.swift
//  Contacts
//
//  Created by Mohsen Abdollahi on 5/8/20.
//  Copyright © 2020 Mohsen Abdollahi. All rights reserved.
//

import SwiftUI

enum SectionType {
    case ceo
    case peasants
}

struct Contact: Hashable {
    let name: String
}

struct ContactRowView: View {
    
    var name: String = " Test"
    @ObservedObject var viewModel: ContactViewModel
    
    var body: some View {
        HStack{
            Image(systemName: "person.fill")
            Text(viewModel.name)
            Spacer()
            Image(systemName: "star")
        }.padding(20)

        }
    }


class ContactViewModel: ObservableObject{
    @Published var name = ""
}

class ContactCell: UITableViewCell {
    
    var viewModel = ContactViewModel()

    lazy var row = ContactRowView( viewModel: viewModel)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//      backgroundColor = .red
        let hostingController = UIHostingController(rootView: row )
        self.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
  
//        row.name = "MY Name"
        viewModel.name = "Something in here"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DiffableTableViewController: UITableViewController{
    
    lazy var source: UITableViewDiffableDataSource<SectionType, Contact> = .init(tableView: self.tableView) { (_, indexPath, contact) -> UITableViewCell? in
        
        let cell = ContactCell(style: .default, reuseIdentifier: nil)
//        cell.textLabel?.text = "SOME NAME HERE"
//        cell.textLabel?.text = contact.name
        cell.viewModel.name = contact.name
        
        return cell
    }

    private func setupSource(){

        var snapshot = source.snapshot()
        snapshot.appendSections([.ceo, .peasants])
        
        snapshot.appendItems([.init(name: "Elon Musk"),
                              .init(name: "Tim Cook"),
                              .init(name: "WhatEver")], toSection: .ceo)
        
        snapshot.appendItems([.init(name: "Bill Gates ")], toSection: .peasants)

        source.apply(snapshot)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text =  section == 0 ? "CEO" : "Peasnts"
        
//        if section == 0 {
//            label.text = "CEO"
//        } else {
//            label.text = "Peasants"
//        }
//
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSource()
    }
}

struct DiffabelContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
//        DiffableTableViewController()
        UINavigationController(rootViewController: DiffableTableViewController(style: .insetGrouped))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiffabelContainer()
    }
}

//struct ContentView: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}
