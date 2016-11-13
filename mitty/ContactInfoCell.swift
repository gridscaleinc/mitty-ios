import UIKit
import PureLayout

class ContactInfoCell: UICollectionViewCell {
    static let id = "contact-info-cell"
    
    // MARK: - View Elements
    var contact : SocialContactInfo?
    
    let itemImageView: UIImageView
    let name: UILabel
    let status : UILabel
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        itemImageView = UIImageView.newAutoLayout()
        itemImageView.clipsToBounds=true
        itemImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        name = UILabel.newAutoLayout()
        status = UILabel.newAutoLayout()
        
        super.init(frame: frame)
        
        addSubviews()
        configureSubviews()
        addConstraints()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(name)
        contentView.addSubview(status)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        itemImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 2)
        itemImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        itemImageView.autoSetDimension(.height, toSize: 60)
        itemImageView.autoSetDimension(.width, toSize: 60)

        
        name.autoPinEdge(.left, to: .right, of: itemImageView, withOffset: 3.0)
        name.autoPinEdge(.top, to: .top, of: itemImageView)
        name.autoSetDimension(.height, toSize: 30)
        name.autoSetDimension(.width, toSize: 130)

        status.autoPinEdge(toSuperviewEdge: .right, withInset: 2)
        status.autoPinEdge(.top, to: .top, of: itemImageView)
        status.autoSetDimension(.height, toSize: 30)
        status.autoSetDimension(.width, toSize: 70)
        
    }
    
    func configureView(contact: SocialContactInfo) {
        
        self.contact = contact
        
        name.numberOfLines = 1
        name.font = UIFont.boldSystemFont(ofSize: 15)
        name.text = contact.name
        
        itemImageView.image = UIImage(named: contact.imageUrl)
        status.text = "Online"
        
    }

}
