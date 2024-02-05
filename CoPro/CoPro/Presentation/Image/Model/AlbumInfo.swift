//
//  AlbumInfo.swift
//  CoPro
//
//  Created by 문인호 on 2/5/24.
//

import Photos

struct AlbumInfo: Identifiable {
    let id: String?
    let name: String
    let album: PHFetchResult<PHAsset>
    
    init(fetchResult: PHFetchResult<PHAsset>, albumName: String) {
        id = nil
        name = albumName
        album = fetchResult
    }
}
