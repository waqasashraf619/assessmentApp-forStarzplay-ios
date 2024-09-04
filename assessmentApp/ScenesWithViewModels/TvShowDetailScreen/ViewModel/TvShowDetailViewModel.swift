//
//  TvShowDetailViewModel.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

class TvShowDetailViewModel: TvShowDetailViewModelInteface {
    
    //For UI
    var firstLoad: Bool
    
    //For API
    var showId: Int?
    var selectedSeason: Bindable<SeasonModel> = Bindable<SeasonModel>()
    var tvShowDetailResponse: Bindable<ShowDetailResponse>
    var seasonDetailResponse: Bindable<SeasonModel>
    private var tvDetailService: any ServicesDelegate
    private var seasonDetailService: any ServicesDelegate
    
    init(firstLoad: Bool = true, showId: Int? = nil, tvShowDetailResponse: Bindable<ShowDetailResponse> = Bindable<ShowDetailResponse>(), seasonDetailResponse: Bindable<SeasonModel> = Bindable<SeasonModel>(), tvDetailService: any ServicesDelegate = TvShowDetailService(), seasonDetailService: any ServicesDelegate = SeasonDetailService()) {
        self.firstLoad = firstLoad
        self.showId = showId
        self.tvShowDetailResponse = tvShowDetailResponse
        self.tvDetailService = tvDetailService
        self.seasonDetailResponse = seasonDetailResponse
        self.seasonDetailService = seasonDetailService
    }
    
    func fetchTvShowDetails() {
        tvDetailService.tvShowDetailApi(showId: showId) { [weak self] result in
            switch result{
            case .success((var data, _)):
                if var firstSeason = data?.seasons?.first {
                    firstSeason.isSelected = true
                    data?.seasons?.remove(at: 0)
                    data?.seasons?.insert(firstSeason, at: 0)
                }
                self?.tvShowDetailResponse.value = data
                self?.selectedSeason.value = data?.seasons?.first
                self?.firstLoad = false
            case .failure(let error):
                print(error.localizedDescription)
                self?.tvShowDetailResponse.value = nil
                self?.firstLoad = false
            }
        }
    }
    
    func fetchSeasonDetails() {
        seasonDetailService.seasonDetailApi(seasonNo: selectedSeason.value?.seasonNumber, showId: showId) { [weak self] result in
            switch result{
            case .success((let data, _)):
                self?.seasonDetailResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func selectSeason(indexPath: IndexPath) {
        
        var mutableData: ShowDetailResponse? = tvShowDetailResponse.value
        var selectedSeasonData: SeasonModel?
        for (index, season) in (mutableData?.seasons ?? []).enumerated() {
            mutableData?.seasons?[index].isSelected = index == indexPath.row
            if index == indexPath.row {
                selectedSeasonData = season
            }
        }
        tvShowDetailResponse.value = mutableData
        if selectedSeasonData?.seasonNumber != selectedSeason.value?.seasonNumber {
            selectedSeason.value = selectedSeasonData
        }
        
    }
    
}

//MARK: Interface
protocol TvShowDetailViewModelInteface {
    
    var firstLoad: Bool { get set }
    
    var showId: Int? { get set }
    var tvShowDetailResponse: Bindable<ShowDetailResponse> { get set }
    var seasonDetailResponse: Bindable<SeasonModel> { get set }
    var selectedSeason: Bindable<SeasonModel> { get set }
    
    func selectSeason(indexPath: IndexPath)
    func fetchTvShowDetails()
    func fetchSeasonDetails()
    
}
