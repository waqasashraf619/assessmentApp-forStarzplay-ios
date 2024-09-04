//
//  TvShowDetailScreen.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import UIKit
import AVKit

class TvShowDetailScreen: UIViewController {
    
    static let identifier = "TvShowDetailScreen"
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showTitleLbl: UILabel!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var showGeneralInfoLbl: UILabel!
    @IBOutlet weak var showBriefDescLbl: UILabel!
    @IBOutlet weak var navigationBar: UIStackView!
    
    @IBOutlet weak var seasonsCollectionView: UICollectionView!
    @IBOutlet weak var episodesTableView: UITableView!
    
    @IBOutlet weak var episodesTableHeight: NSLayoutConstraint!
    
    private var viewModel: TvShowDetailViewModelInteface
    
    init?(coder: NSCoder, viewModel: TvShowDetailViewModelInteface) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUiElements()
        callShowApis()
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            self.episodesTableHeight.constant = self.episodesTableView.contentSize.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Add Custom nav bar
        addCustomNavBar()
        
        //Add System nav bar
//        addSystemNavbar(animated: animated)
        
    }
    
    private func addCustomNavBar(){
        navigationBar.removeAllSubviews()
        CustomNavigationBar.addNavBar(parentView: navigationBar, insert: true, backgroundColor: .clear, lineSeparatorColor: .clear, leadingImage: .systemleftArrowIcon, leadImageTintColor: .white, title: "", titleColor: .white, trailingLeadImage: .systemTvFeedIcon, trailingLeadImageTintColor: .white, trailingImage: .systemSearchIcon, trailingImageTintColor: .white) { btnIndex, _ in
            if btnIndex == 0 {
                print("Back btn pressed")
            }
        }
    }
    
    private func addSystemNavbar(animated: Bool){
        let leftArrowItem: UIBarButtonItem = UIBarButtonItem(image: .systemleftArrowIcon, style: .plain, target: self, action: #selector(backAction))
        let searchBarItem: UIBarButtonItem =  UIBarButtonItem(image: .systemSearchIcon, style: .plain, target: self, action: nil)
        let tvIconBarItem: UIBarButtonItem = UIBarButtonItem(image: .systemTvFeedIcon, style: .plain, target: self, action: nil)
        leftArrowItem.tintColor = .white
        searchBarItem.tintColor = .white
        tvIconBarItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftArrowItem
        navigationItem.rightBarButtonItems = [searchBarItem, tvIconBarItem]
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUiElements(){
        
        //Register cells
        registerCells()
        
        /**/
        imageContainerView.layer.masksToBounds = false
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOpacity = 0.9
        imageContainerView.layer.shadowOffset = CGSize(width: -1, height: 1)
        imageContainerView.layer.shadowRadius = 15
        
        imageContainerView.layer.shadowPath = UIBezierPath(rect: CGRect(x: imageContainerView.bounds.minX, y: imageContainerView.bounds.maxY - 40, width: imageContainerView.bounds.width, height: 60)).cgPath
        imageContainerView.layer.shouldRasterize = true
//        imageContainerView.layer.rasterizationScale = 
         
        
    }
    
    private func registerCells() {
        let seasonCell: UINib = UINib(nibName: SeasonTitleCell.identifier, bundle: .main)
        seasonsCollectionView.register(seasonCell, forCellWithReuseIdentifier: SeasonTitleCell.identifier)
        let episodeCell: UINib = UINib(nibName: EpisodeInfoCell.identifier, bundle: .main)
        episodesTableView.register(episodeCell, forCellReuseIdentifier: EpisodeInfoCell.identifier)
    }
    
    @objc
    private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func callShowApis(){
        viewModel.fetchTvShowDetails()
        ActivityIndicator.shared.showActivityIndicator(view: view, showBackground: true)
    }
    
    private func callSeasonApi(){
        if !viewModel.firstLoad {
            DispatchQueue.main.async {
                ActivityIndicator.shared.showActivityIndicatorOnBottom(view: self.view)
            }
        }
        viewModel.fetchSeasonDetails()
    }
    
    private func mapShowData(data: ShowDetailResponse?){
        guard let data else { return }
        showImage.setRemoteImage(urlString: data.backdropPath)
        showTitleLbl.text = data.name
        showGeneralInfoLbl.text = data.showStatInfoString
        showBriefDescLbl.text = data.overview
    }
    
    deinit {
        print("Tv Show Screen deinitialized")
    }
    
    private func showMedia(){
        guard let vc = servicesInitilizationManager?.appVCs.playerScreen(viewModel: PlayerViewModel(fileUrl: VideoUrlContent.sampleVideo.rawValue)) else { return }
        vc.modalPresentationStyle = .fullScreen
        showDetailViewController(vc, sender: self)
    }
    
    //MARK: ButtonActions
    @IBAction func readMoreBtn(_ sender: Any) {
        showBriefDescLbl.numberOfLines = showBriefDescLbl.numberOfLines > 0 ? 0 : 3
        readMoreBtn.setTitle(showBriefDescLbl.numberOfLines > 0 ? "Read More" : "Less -", for: .normal)
        animateView()
    }
    @IBAction func playBtn(_ sender: Any) {
        showMedia()
    }
    
    @IBAction func trailerBtn(_ sender: Any) {
        showMedia()
    }
}

extension TvShowDetailScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.tvShowDetailResponse.value?.seasons?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = seasonsCollectionView.dequeueReusableCell(withReuseIdentifier: SeasonTitleCell.identifier, for: indexPath) as! SeasonTitleCell
        let data: SeasonModel? = viewModel.tvShowDetailResponse.value?.seasons?[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectSeason(indexPath: indexPath)
    }
    
}

extension TvShowDetailScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.seasonDetailResponse.value?.episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodesTableView.dequeueReusableCell(withIdentifier: EpisodeInfoCell.identifier, for: indexPath) as! EpisodeInfoCell
        let data: EpisodeModel? = viewModel.seasonDetailResponse.value?.episodes?[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showMedia()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
}

extension TvShowDetailScreen {
    
    private func bindViewModel(){
        
        viewModel.tvShowDetailResponse.bind { [weak self] response in
            if let response {
                DispatchQueue.main.async {
                    self?.mapShowData(data: response)
                    self?.seasonsCollectionView.reloadData()
                }
            }
            else {
                ActivityIndicator.shared.removeActivityIndicator()
            }
        }
        
        viewModel.seasonDetailResponse.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            DispatchQueue.main.async {
                self?.episodesTableView.reloadData()
                self?.seasonsCollectionView.reloadData()
            }
        }
        
        viewModel.selectedSeason.bind { [weak self] selectedSeason in
            self?.callSeasonApi()
        }
        
    }
    
}
