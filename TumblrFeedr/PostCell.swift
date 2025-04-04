//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Phanuelle Manuel on 4/3/25.
//

import UIKit
import Nuke

class PostCell: UITableViewCell {
//    @IBOutlet weak var postImageView: UIImageView!
//    @IBOutlet weak var summaryLabel: UILabel!
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Allow multiple lines
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        Nuke.cancelRequest(for: postImageView)
        postImageView.image = nil
        summaryLabel.text = ""
    }


    // Add subviews and set constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(postImageView)
        contentView.addSubview(summaryLabel)

        NSLayoutConstraint.activate([
            // ImageView constraints
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            postImageView.widthAnchor.constraint(equalToConstant: 100),
            postImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),

            // Label constraints
            summaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 8),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
