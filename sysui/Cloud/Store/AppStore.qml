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

import QtQuick 2.0
import "JSONBackend.js" as JSONBackend
import com.pelagicore.ApplicationManager 0.1

Item {

    property bool serverOnline: false
    property string serverReason
    property string server: ApplicationManager.additionalConfiguration.appStoreServerUrl

    signal loginSuccessful()

    function goBack() {
        if (categoriesPage.state != "")
            categoriesPage.goBack()
        else
            root.close();
    }

    function checkServer() {
        print("#####################checkserver#####################")
        var url = server + "/hello"
        var data = {"platform" : "AM", "version" : "1"}
        JSONBackend.setErrorFunction(function () {
            serverOnline = false
            serverReason = "unknown"
        })
        JSONBackend.serverCall(url, data, function(data) {
            if (data !== 0) {
                if (data.status == "ok") {
                    serverOnline = true
                    login()
                    //refresh()
                } else if (data.status == "maintenance") {
                    serverOnline = false
                    serverReason = "maintenance"
                } else {
                    print("HELLO ERROR: " + data.error)
                    serverOnline = false
                }
            } else {
                serverOnline = false
                serverReason = "unknown"
            }
        })
    }

    function login() {
        var url = server + "/login"
        var data = {"username" : "t", "password" : "t", "imei" : "112163001487801"}
        JSONBackend.serverCall(url, data, function(data) {
            if (data !== 0) {
                if (data.status == "ok") {
                    print("LOGIN SUCCESSFUL");
                    loginSuccessful()
                } else {
                    print("LOGIN ERROR: " + data.error)
                }
            }
        })
    }
    Component.onCompleted: checkServer()
}