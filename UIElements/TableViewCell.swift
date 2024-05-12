//
//  TableViewCell.swift
//  DotaHeroes
//
//  Created by Artem Morozov on 12.05.2024.
//

import UIKit

final class TableViewCell: UITableViewCell {

    @IBOutlet weak var heroIconImageView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var atributeImageView: UIImageView!
    
    
    static let reuseIdentifier = "ImagesListCell"
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//    }

    override func prepareForReuse() {
        super.prepareForReuse()
        heroIconImageView.image = UIImage()
    }

}
