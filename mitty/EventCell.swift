import UIKit
import PureLayout

class EventCell: UICollectionViewCell {
    static let id = "journey-search-result-cell"
    // MARK: - View Elements
    let itemImageView: UIImageView
    let titleLabel: UILabel
    let priceLabel: UILabel
    let bidLabel: UILabel
    let endTimeLabel: UILabel
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        itemImageView = UIImageView.newAutoLayout()

        titleLabel = UILabel.newAutoLayout()
        priceLabel = UILabel.newAutoLayout()
        bidLabel = UILabel.newAutoLayout()
        endTimeLabel = UILabel.newAutoLayout()
        
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(bidLabel)
        contentView.addSubview(endTimeLabel)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        itemImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 2)
        itemImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        itemImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 2)
        
        itemImageView.autoMatch(.height, to: .width, of: itemImageView)
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: itemImageView, withOffset: 3.0)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 2)

        priceLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 3.0)
        priceLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        priceLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 2)

        endTimeLabel.autoPinEdge(.top, to: .bottom, of: priceLabel, withOffset: 3.0)
        endTimeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        endTimeLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)

        bidLabel.autoPinEdge(.top, to: .bottom, of: priceLabel, withOffset: 3.0)
        bidLabel.autoPinEdge(.left, to: .right, of: endTimeLabel, withOffset: 10.0)
        bidLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)

    }
    
    func configureView(auction: Event) {
        itemImageView.image = auction.image

        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        titleLabel.text = auction.title

        priceLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        priceLabel.text = "現在 " + String(auction.price) + "円"

        endTimeLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
        endTimeLabel.text = "🕒" + auction.endTime

        bidLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
        bidLabel.text = "🔨" + String(auction.bidCount)
    }
}
