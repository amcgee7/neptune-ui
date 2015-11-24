/****************************************************************************
**
** Copyright (C) 2015 Pelagicore AG
** Contact: http://www.pelagicore.com/
**
** This file is part of Neptune IVI UI.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Neptune IVI UI licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Pelagicore. For licensing terms
** and conditions see http://www.pelagicore.com.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU General Public License version 3 requirements will be
** met: http://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Layouts 1.0
import controls 1.0
import utils 1.0

UIElement {
    id: root

    hspan: 18
    vspan: 24

    ListViewManager {
        id: settingsListView

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(1)
        hspan: 12
        height: parent.height

        model: ListModel {
            ListElement { title: "Steering wheel gearshift paddles" }
            ListElement { title: "Combination switch" }
            ListElement { title: "Instrument cluster" }
            ListElement { title: "Horn" }
            ListElement { title: "DIRECT SELECT lever" }
            ListElement { title: "PARKTRONIC warning display" }
            ListElement { title: "Overhead control panel" }
        }

        delegate: SettingsListItem {
            hspan: settingsListView.hspan
            vspan: 2
            checkedEnabled: false
            iconName: "information"
            titleText: model.title
        }
    }
}