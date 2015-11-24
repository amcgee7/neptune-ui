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
    property real value: 0
    property int upDuration: 2000
    property int downDuration: 1000

    width: meter.width
    height: meter.height

    Image {
        id: meter
        property real min: -83.5
        property real max: 157

        rotation: min + (max - min) * root.value

        source: Style.gfx("cluster/dial_cursor")

        ShaderEffect {
            anchors.fill: parent
            property var pattern: Image {
                source: Style.gfx("cluster/dial_pattern")
            }
            property var fill: Image {
                source: Style.gfx("cluster/dial_fill_color")
            }
            property real value: root.value

            fragmentShader: "
    #define M_PI 3.141592653589793
    #define INNER 0.213

    varying highp vec2 qt_TexCoord0;
    uniform lowp float qt_Opacity;
    uniform sampler2D pattern;
    uniform sampler2D fill;
    uniform lowp float value;

    void main() {
        lowp vec4 pattern = texture2D(pattern, qt_TexCoord0);
        lowp vec4 fill = texture2D(fill, qt_TexCoord0);

        lowp vec2 pos = vec2(qt_TexCoord0.x - 0.5, 0.501 - qt_TexCoord0.y);
        lowp float d = length(pos);
        lowp float angle = atan(pos.x, pos.y) / (2.0 * M_PI);
        lowp float v = 0.66 * value - 0.33;

        // Flare pattern
        lowp vec4 color = mix(pattern, vec4(0.0), smoothstep(v, v + 0.1, angle));
        // Gradient fill color
        color += mix(fill, vec4(0.0), step(v, angle));
        // Punch out the center hole
        color = mix(vec4(0.0), color, smoothstep(INNER - 0.001, INNER + 0.001, d));
        // Fade out below 0
        gl_FragColor = mix(color, vec4(0.0), smoothstep(-0.35, -0.5, angle));
    }
            "
        }
    }
}