//
//  CustomFlussonicTheme.swift
//  FlussonicIso
//
//  Created by otvazhniy on 15.03.2021.
//  Copyright © 2021 Erlyvideo. All rights reserved.
//

import Foundation
import FlussonicSDK

struct CustomFlussonicTheme: Codable {
    /// timeline background with no chunks => onBtnColor
    static let fs_chart_background = UIColor.init(rgba: "#cccccc")
    /// ruler color white
    static let fs_ruler_line = UIColor.init(rgba: "#323232")
    /// onSurfaceColor
    static let fs_loading_range = UIColor.init(rgba: "#969DA3")
    /// btnColor
    static let fs_range = UIColor.init(rgba: "#bbdd00")
    /// transparent background for cutOpen timeline
    static let fs_cut_range = UIColor.init(rgba: "#00000046")
    /// backgroundCommon
    static let fs_pause_button_pressed = UIColor.init(rgba: "#181818D8")
    /// btnColor
    static let fs_progress_bar: UIColor = fs_range
    /// statusOk
    static let fs_camera_status_icon_active = UIColor.init(rgba: "#42D921")
    /// statusError
    static let fs_camera_status_icon_inactive = UIColor.init(rgba: "#F2184D")
    /// bottom toolbar gradient color
    static let fs_bottom_bar_gradient1 = UIColor.init(rgba: "#ffffff55")
    static let fs_bottom_bar_gradient2 = UIColor.init(rgba: "#ffffff77")
    /// onSurfaceTitleColor
    static let fs_bottom_bar_date_text = UIColor.init(rgba: "#000000")

    static let fs_bottom_bar_icon = UIColor.init(rgba: "#00aa00aa")
    /// statusError
    static let fs_event: UIColor = fs_camera_status_icon_inactive
    static let fs_event_vehicle: UIColor = fs_camera_status_icon_inactive
    static let fs_event_face: UIColor = fs_camera_status_icon_inactive
    /// numbers color on timeline
    static let fs_time_label: UIColor = fs_ruler_line
    /// time color for cutOpen => onSurfaceColor
    static let fs_cut_value = UIColor.init(rgba: "#000000")
    /// onSurfaceBgColor
    static let fs_cut_label = UIColor.init(rgba: "#000000aa")
    /// surfaceColorVariant + iconOpacity
    static let fs_cut_timestamp_background = UIColor.init(rgba: "#000000aa")
    /// borderColor => primaryLight
    static let fs_bottom_bar_divider = UIColor.init(rgba: "#00000077")
    /// onSurfaceBgColor
    static let fs_dash: UIColor = fs_cut_timestamp_background

    static func toDict() -> [String: String] {
        return [
            "fs_chart_background": fs_chart_background.hexString(true), // "#cccccc",
            "fs_ruler_line": fs_ruler_line.hexString(true), // "#323232",
            "fs_loading_range": fs_loading_range.hexString(true), // "#969DA3",
            "fs_range": fs_range.hexString(true), // "#bbdd00",
            "fs_cut_range": fs_cut_range.hexString(true), // "#00000046",
            "fs_pause_button_pressed": fs_pause_button_pressed.hexString(true), // "#181818D8",
            "fs_camera_status_icon_active": fs_camera_status_icon_active.hexString(true), // "#42D921",
            "fs_camera_status_icon_inactive": fs_camera_status_icon_inactive.hexString(true), // "#F2184D",
            "fs_bottom_bar_gradient1": fs_bottom_bar_gradient1.hexString(true), // "#ffffff",
            "fs_bottom_bar_gradient2": fs_bottom_bar_gradient2.hexString(true), // "#ffffff",
            "fs_bottom_bar_date_text": fs_bottom_bar_date_text.hexString(true), // "#323232",
            "fs_bottom_bar_icon": fs_bottom_bar_icon.hexString(true), // "#969DA3",
            "fs_cut_value": fs_cut_value.hexString(true), // "#212121",
            "fs_cut_label": fs_cut_label.hexString(true), // "#454952",
            "fs_cut_timestamp_background": fs_cut_timestamp_background.hexString(true), // "#cccccc",
            "fs_bottom_bar_divider": fs_bottom_bar_divider.hexString(true), // "#cccccc",
            "fs_dash": fs_dash.hexString(true)
        ]
    }
}
