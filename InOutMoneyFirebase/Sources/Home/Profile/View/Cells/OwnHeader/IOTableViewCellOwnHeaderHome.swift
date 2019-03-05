//
//  IOTableViewCellOwnHeaderHome.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 4/3/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOTableViewCellOwnHeaderHomeDelegate: class {
    func didTappedDelegate(keyName: String)
}

class IOTableViewCellOwnHeaderHome: UITableViewCell {

    weak var delegate : IOTableViewCellOwnHeaderHomeDelegate?
    var keyName : String = ""
    
    @IBOutlet var titleCell: UILabel!
    @IBOutlet var fondoView: UIView!
    @IBOutlet var fondoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        fondoView.layer.backgroundColor = UIColor.clear.cgColor
        fondoImageView.layer.cornerRadius = fondoView.frame.height/2
        fondoImageView.layer.shadowColor = UIColor.blue.cgColor
        fondoImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        //fondoImageView.layer.shadowRadius = fondoView.frame.height/2
        fondoImageView.layer.shadowOpacity = 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        fondoView.addGestureRecognizer(tap)
    }
    
    @objc func tapped() {
        fondoView.buttonAnimation()
        self.delegate?.didTappedDelegate(keyName: keyName)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var item: HomeProfileViewModelItem? {
        didSet {
            guard let item = item as? HomeProfileViewModelOwnHeaderItem else {
                return
            }
            
            titleCell?.text = item.title
            keyName = item.keyName
        }
    }
}
