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
import utils 1.0

Item {
    id: root

    width: 1920
    height: 720

    property bool zoom: false

    Image {
        anchors.fill: parent
        source: Style.gfx("cluster/background")
    }

    Middle {
        id: widgetBase
        anchors.centerIn: parent
        onZoomIn: {
            widgetBase.width = 1000
            root.zoom = true
        }

        onZoomOut: {
            widgetBase.width = 700
            root.zoom = false
        }
    }

    LeftDial {
        id: leftDial
        x: root.zoom ? -230 : 0
        zoom: root.zoom
    }

    RightDial {
        id: rightDial
        x: root.zoom ? 1240 : (1920 - width)
        zoom: root.zoom
    }

    Top {
        id: topbar
        y: root.zoom ? - topbar.height : 11
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Notifications {
        id: notifications
        y: root.zoom ? root.height : root.height - notifications.height - 15
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        anchors.fill: parent
        source: Style.gfx("cluster/mask_overlay")
    }

    focus: Style.debugMode

    Keys.onPressed: {
        if (event.key == Qt.Key_Space) {
            if (overlay.opacity < 0.5) overlay.opacity = 0.5
            else overlay.opacity = 0
        }
    }

    Keys.forwardTo: Style.debugMode ? [layouter] : null

    property var layoutTarget: notifications

    Layouter {
        id: layouter
        target: layoutTarget
    }
}