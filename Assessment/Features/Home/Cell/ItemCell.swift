//
//  ItemCell.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 26/12/2023.
//

import Foundation
import UIKit
import RxSwift

class ItemCell: UITableViewCell{
    @IBOutlet var lblWebName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var btnMenu: UIButton!
    
    var disposeBag = DisposeBag()
    var menuback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bindView() {
        self.btnMenu.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.menuback?()
        }).disposed(by: self.disposeBag)
        
    }
    
    var model: AccountItems? {
        didSet {
            guard let model = model else { return }
            self.lblEmail.text = model.email
            self.lblWebName.text = model.webName
        }
    }
    
}
