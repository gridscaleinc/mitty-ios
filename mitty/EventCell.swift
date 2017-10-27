import UIKit
import PureLayout

class EventCell: UICollectionViewCell {
    static let id = "journey-search-result-cell"

    // MARK: - View Elements
    var event: EventInfo!

    var form = MQForm.newAutoLayout()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// <#Description#>
    private func addConstraints() {


    }

    /// <#Description#>
    ///
    /// - Parameter event: <#event description#>
    func configureView(event: EventInfo) {

        self.event = event
        form = MQForm.newAutoLayout()
        self.addSubview(form)
        form.autoPinEdgesToSuperviewEdges()

        let section = Section(name: "eventcell", view: UIView.newAutoLayout())
        section.layout {
            s in
            s.fillParent()
        }
        
        form +++ section
        
        // タイトル行（タイトル、アイコン）
        layoutTitle(section)

        // いつから、残り何日（カウントダウン）
        layoutTerm(section)
 
        // 画像
        layoutImage(section)

        // Likes
        layoutLikesAndPoster(section)
        
        // 説明
        layoutDescription(section)

        let bottom = Row.LeftAligned()
        section <<< bottom
        
        // layout設定
        form.configLayout()

    }

    
    /// <#Description#>
    ///
    /// - Parameter section: <#section description#>
    func layoutTitle(_ section: Section) {
        let row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        
        if event.eventLogo != nil {
            // imageがある場合、イメージを表示
            let itemImage = MQForm.img(name: "eventImage", url: event.eventLogoUrl).layout {
                img in
                img.width(35).height(35).verticalCenter().leftMargin(10)
                img.imageView.image = self.event.eventLogo
            }
            row +++ itemImage
        } else {
            row +++ MQForm.img(name: "eventLogo", url: "timesquare").layout {
                i in
                i.width(35).height(35).verticalCenter().leftMargin(10)
            }
        }
        
        let titleLabel = MQForm.label(name: "titleLabel", title: event.title).layout { t in
            t.label.numberOfLines = 2
            t.label.font = UIFont.boldSystemFont(ofSize: 18)
            t.label.adjustsFontSizeToFitWidth = true
            t.verticalCenter().leftMargin(5).rightMost(withInset: 5)
            t.label.textColor = MittyColor.healthyGreen
        }
        
        row +++ titleLabel
        
        
        section <<< row

    }
    
    /// <#Description#>
    ///
    /// - Parameter section: <#section description#>
    func layoutTerm(_ section: Section) {
        
        // 日付情報を設定
        let row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(34)
        }
        
        row.spacing = 10
        
        let remainder = event.endDate.timeIntervalSinceNow / 86400
        let tillStart = event.startDate.timeIntervalSinceNow / 86400
        
        var remainDays = ""
        let duration = event.duration()
        row +++ MQForm.label(name: "duration", title: duration).layout {
            d in
            d.leftMost(withInset:5).rightMargin(10).verticalCenter()
            d.label.adjustsFontSizeToFitWidth = true
            d.label.textColor = UIColor.gray
        }
        // 未開始
        if (tillStart > 0) {
            remainDays = "開始まで\(Int(tillStart))日"
            // 開始まで１日を切った場合
            if tillStart < 1 {
                remainDays = "開始まで\(Int(tillStart*24))時間"
            }
            
            // 開始まで1時間を切った場合
            if tillStart < (1/24) {
                remainDays = "開始まで\(Int(tillStart*24*60))分"
            }
            
        // 進行中
        } else if (tillStart <= 0 && remainder > 0) {
            remainDays = "終了まで\(Int(remainder))日"
            // 終了まで１日を切った場合
            if remainder < 1 {
                remainDays = "終了まで\(Int(remainder*24))時間"
            }
            
            // 開始まで1時間を切った場合
            if remainder < (1/24) {
                remainDays = "終了まで\(Int(remainder*24*60))分"
            }
            
        // 完了
        } else if remainder <= 0 {
            remainDays = "完了しました"
        // else はありえない、意味不明
        } else {
            remainDays = "日程不明"
        }
        
        let termStatus = MQForm.hilight(label: remainDays, named:"termStatus")
        
        row +++ termStatus.layout {
            pub in
            pub.height(28).verticalCenter()
            let l = pub.label
            l.textAlignment = .center
            l.adjustsFontSizeToFitWidth = true
            l.font = UIFont.boldSystemFont(ofSize: 12)
            l.textColor = UIColor.darkGray
        }
        
        section <<< row
        
    }

    /// <#Description#>
    ///
    /// - Parameter section: <#section description#>
    func layoutImage(_ section: Section) {
        
        
        if event.coverImage != nil {
            let height = (UIScreen.main.bounds.width - 30) * event.coverImage!.size.ratio
            // imageがある場合、イメージを表示
            let itemImage = MQForm.tapableImg(name: "eventImage", url: event.coverImageUrl).layout {
                img in
                img.fillHolizon().height(height).upper()
                img.imageView.image = self.event.coverImage
            }
            
            let row = Row.LeftAligned().layout {
                r in
                r.fillHolizon().height(height)
            }
            
            let container = Row.LeftAligned().layout {
                r in
                r.fillHolizon().height(height).upper()
            }
            
            container +++ itemImage
            
            let col = Col.UpDownAligned().layout {
                c in
                c.leftMost(withInset: 10).width(60).height(65).upper(withInset: 10)
                c.view.backgroundColor = MittyColor.red.withAlphaComponent(0.5)
                c.view.layer.cornerRadius = 1
                c.view.layer.masksToBounds = true
                c.view.layer.shadowColor = UIColor.gray.cgColor
                c.view.layer.shadowOpacity = 0.4
                c.view.layer.shadowOffset = CGSize(width: 1, height: 1)
                c.view.layer.shadowRadius = 3
            }
            
            container +++ col
            
            col +++ MQForm.label(name: "day", title: event.startDate.day99).layout {
                l in
                l.height(30).holizontalCenter()
                l.label.adjustsFontSizeToFitWidth = true
                l.label.textColor = UIColor.black
                l.label.textAlignment = .center
                l.label.font = UIFont.systemFont(ofSize: 28)
            }
            col +++ MQForm.label(name: "monthyear", title: event.startDate.monthYear).layout {
                l in
                l.height(18).holizontalCenter()
                l.label.adjustsFontSizeToFitWidth = true
                l.label.textColor = UIColor.white
                l.label.textAlignment = .center
                l.label.font = UIFont.systemFont(ofSize: 10)
            }
            col +++ MQForm.label(name: "minute", title: event.startDate.time12).layout {
                l in
                l.height(15).holizontalCenter()
                l.label.adjustsFontSizeToFitWidth = true
                l.label.textColor = UIColor.white
                l.label.textAlignment = .center
                l.label.font = UIFont.systemFont(ofSize: 10)
            }
        
            row +++ container
            
            section <<< row
            
        }

        
    }
    
    /// <#Description#>
    ///
    /// - Parameter section: <#section description#>
    func layoutLikesAndPoster(_ section: Section) {
        // logoがある場合ロゴを表示
        let row = Row.Intervaled().layout {
            r in
            r.height(40)
        }

        let left = Row.LeftAligned().height(30)
        row +++ left
        left +++ MQForm.label(name: "likes1", title: "❤️").layout {
            l in
            l.width(25).height(25).leftMargin(10).verticalCenter()
        }
        left +++ MQForm.label(name: "likes2", title: "\(event.likes) いいね！").layout {
            l in
            l.height(25).width(80).leftMargin(5).verticalCenter()
            let label = l.label
            label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
            label.textAlignment = .left
        }
        
        let right = Row.LeftAligned().layout {
            r in
            r.height(30).verticalCenter()
        }
        row +++ right
        
        let publisherIcon = MQForm.img(name: "pushlisherIcon", url: "")
        if (event.publisherIcon != nil) {
            publisherIcon.imageView.image = event.publisherIcon
        }
        
        right +++ publisherIcon.width(25).height(25).layout {
            icon in
            icon.verticalCenter()
        }
        
        let publisher = MQForm.label(name: "publisher", title: "by " + event.publisherName + " " + event.publishedDays + "Days")
        
        right +++ publisher.layout {
            pub in
            pub.leftMargin(20).verticalCenter()
            let l = pub.label
            l.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.textColor = UIColor.gray
        }
        
        section <<< row
        

    }
    
    /// <#Description#>
    ///
    /// - Parameter section: <#section description#>
    func layoutDescription(_ section: Section) {
        let row = Row.LeftAligned()
        let actionLabel = UILabel.newAutoLayout()
        actionLabel.text = event.action
        let actionCtrl = Control(name: "actionLabel", view: actionLabel).layout {
            l in
            l.fillHolizon(10).upper(withInset: 3).leftMargin(5).taller(than: 40)
            l.label.font = UIFont.systemFont(ofSize: 12)
            l.label.textColor = UIColor(white: 0.33, alpha: 1)
            l.label.numberOfLines = 0
        }
        row.layout {
            r in
            r.fillHolizon().bottomAlign(with: actionCtrl)
            r.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
//            r.view.layer.borderColor = UIColor.blue.cgColor
//            r.view.layer.borderWidth = 1

        }
        row +++ actionCtrl
        section <<< row
    }
    
    /// <#Description#>
    func reloadImages() {
        if let img = event.coverImage {
            if let iv = form.quest("[name=eventImage]").control()?.imageView {
                iv.image = img
            }
        }

        if let img = event.eventLogo {
            form.quest("[name=eventLogo]").control()?.imageView.image = img
        }

        if let img = event.publisherIcon {
            form.quest("[name=pushlisherIcon]").control()?.imageView.image = img
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
        form.removeFromSuperview()
    }
}
