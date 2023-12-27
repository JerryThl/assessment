//
//  HomeVC.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 25/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Toast
import RealmSwift

class HomeVC:UIViewController{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonAdd: UIButton!
    @IBOutlet var lblWelcome: UILabel!
    
    private var disposeBag = DisposeBag()
    private let vm = HomeVM()
    
    override func viewWillAppear(_ animated: Bool) {
        self.vm.getItemsListTrigger()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblWelcome.text = "Welcome,\n\(RealmManager.shared.realm.objects(User.self).first!.email)"
        
        setupTableView()
        bindVM()
    }
    
    private func setupTableView() {
        tableView.register(ItemCell.getNib(), forCellReuseIdentifier: ItemCell.identifier)
        tableView.delegate = self
    }
    
    private func bindVM(){
        let input = HomeVM.Input()
        let output = self.vm.transform(input: input)
        
        output.listItems.bind(to: tableView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) { (row,item,cell) in
            cell.bindView()
            cell.model = item
            cell.menuback = { [weak self] in
                guard let `self` = self else { return }
                let popup = HomeCellMenuPopUp()
                popup.webname.accept(item.webName)
                popup.username = item.username
                popup.password = item.password
                popup.modalPresentationStyle = .overFullScreen
                popup.modalTransitionStyle = .crossDissolve
                self.present(popup, animated: true)

            }
        }.disposed(by: disposeBag)
        
        
        self.buttonAdd.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            self.navigationController?.pushViewController(AddItemVC(), animated: true)
        }).disposed(by: disposeBag)
        
    }
}

extension HomeVC:UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
 
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [self]
            (action, sourceView, completionHandler) in
            
            self.presentAlert(title: "Delete Items", message: "Are you sure you want to delete?", confirmBtn: "Remove", cancelBtn: "Cancel").subscribe(onNext: { _ in
                
                let itemSelected = self.vm.listItems.value[indexPath.row]
                let predicate = NSPredicate(format: "itemId == %@", NSNumber(integerLiteral: itemSelected.itemId))
                let result = RealmManager.shared.realm.objects(AccountItems.self).filter(predicate)
                RealmManager.shared.delete(result.toArray())
                self.vm.getItemsListTrigger()
            }).disposed(by: disposeBag)
            
            completionHandler(true)
           
            
        }
        deleteAction.image = UIImage(named: "swipe_delete")
        deleteAction.backgroundColor = UIColor.init(white: 1, alpha: 0)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
