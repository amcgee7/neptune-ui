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
import QtQuick.Controls 1.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

import controls 1.0
import utils 1.0
import "."

UIScreen {
    id: root
    hspan: 24
    vspan: 24

    title: 'Movies'

    property bool active: false
    property bool hideControls: false

    property var track: MovieProvider.currentEntry


    Video {
        id: video
        anchors.fill: parent
        source: MovieProvider.sourcePath(root.track.source)
        autoPlay: true

        property bool running: playbackState === MediaPlayer.PlayingState

        function togglePlay() {
            if (running) {
                pause()
            } else {
                play()
            }
        }
    }

    Rectangle {
        anchors.fill: toolBar
        anchors.margins: -Style.paddingL
        color: '#000'
        opacity: toolBar.opacity * 0.85
        radius: 8
    }
    ColumnLayout {
        id: toolBar
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.vspan(4)
        spacing: 0
        opacity: root.hideControls?0.0:1.0
        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Style.hspan(2)
            Tool {
                name: 'prev'
                onClicked: MovieService.previous()
            }
            Tool {
                name: video.running?'pause':'play'
                onClicked: video.togglePlay()
            }
            Tool {
                name: 'next'
                onClicked: MovieProvider.next()
            }
        }
        Slider {
            anchors.horizontalCenter: parent.horizontalCenter
            value: video.position
            minimum: 0.00
            maximum: video.duration
            vspan: 1
            function valueToString() {
                return Math.floor(value/60000) + ':' + Math.floor((value/1000)%60)
            }
            onActiveValueChanged: {
                video.seek(activeValue)
            }
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0
            Symbol {
                hspan: 1
                vspan: 2
                size: Style.symbolSizeXS
                name: 'speaker'
            }
            VolumeSlider {
                hspan: 8
                vspan: 2
                anchors.horizontalCenter: parent.horizontalCenter
                value: video.volume
                onValueChanged: {
                    video.volume = value
                }
            }
            Label {
                hspan: 1
                vspan: 2
                text: Math.floor(video.volume*100)
            }
        }

    }

    MouseArea {
        id: clickOverlay
        anchors.fill: parent
        onClicked: {
            root.hideControls = false
            enabled = false
            hideTimer.start()
        }
    }

    Timer {
        id: hideTimer
        interval: 5000
        running: video.running
        onTriggered: {
            root.hideControls = true
            clickOverlay.enabled = true
        }
    }

    Component.onDestruction: {
        // required to avoid crashing qmllive
        video.source = ''
    }
}