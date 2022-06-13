//
//  VideoSearchCell.swift
//  videoTestApp
//
//  Created by admin on 5/30/22.
//

import UIKit

class VideoSearchCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    public var imageURLString = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImageView {
    func loadurl(url: URL) {

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
