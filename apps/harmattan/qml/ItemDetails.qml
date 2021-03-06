/*****************************************************************************
 * Copyright: 2011-2013 Michael Zanetti <michael_zanetti@gmx.net>            *
 *                                                                           *
 * This file is part of Xbmcremote                                           *
 *                                                                           *
 * Xbmcremote is free software: you can redistribute it and/or modify        *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation, either version 3 of the License, or         *
 * (at your option) any later version.                                       *
 *                                                                           *
 * Xbmcremote is distributed in the hope that it will be useful,             *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 * GNU General Public License for more details.                              *
 *                                                                           *
 * You should have received a copy of the GNU General Public License         *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.     *
 *                                                                           *
 ****************************************************************************/

import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: itemDetails
    width: parent.width
    height: parent.height
    //    height: childrenRect.height
    //    clip: true

    signal playItem
    signal addToPlaylist
    signal download

    function askDownload() {
        var component = Qt.createComponent(Qt.resolvedUrl("DownloadDialog.qml"));
        var dialog = component.createObject(itemDetails);
        dialog.itemName = title
        dialog.accepted.connect(download);
        dialog.open();
    }

    Component.onCompleted: print("**************itemHeight: " + height)

    Flickable {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: buttonLoader.top
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        contentWidth: parent.width
        contentHeight: labelColumn.height
        clip: true
        z: 5

        Column {
            id: labelColumn
            spacing: 5
            height: childrenRect.height
            width: parent.width

            Row {
                width: parent.width; spacing: 10; visible: rating > -1
                Label { text: qsTr("Rating:"); font.bold: true }
                property int starCount: rating > 10 ? Math.round(rating / 20) : Math.round(rating / 2)
                Repeater {
                    model: parent.starCount
                    Image {
                        source: theme.inverted ? "image://theme/meegotouch-indicator-rating-inverted-background-star" : "image://theme/meegotouch-indicator-rating-star"
                    }
                }
                Repeater {
                    model: 5 - parent.starCount
                    Image {
                        source: theme.inverted ? "image://theme/meegotouch-indicator-rating-inverted-background-star" : "image://theme/meegotouch-indicator-rating-star"
                        opacity: .4
                    }
                }
            }

            Row {
                width: parent.width; spacing: 10; visible: season > -1
                Label { text: qsTr("Season:"); font.bold: true }
                Label { text: season }
            }

            Row {
                width: parent.width; spacing: 10; visible: episode > -1
                Label { text: qsTr("Episode:"); font.bold: true }
                Label { text: episode }
            }

            Row {
                width: parent.width; spacing: 10; visible: firstaired.length > 0
                Label { text: qsTr("First aired:"); font.bold: true }
                Label { text: firstaired }
            }

            Row {
                width: parent.width; spacing: 10; visible: genre.length > 0
                Label { id: genreLabel; text: qsTr("Genre:"); font.bold: true }
                Label { text: genre; width: parent.width - genreLabel.width - parent.spacing; wrapMode: Text.WordWrap }
            }

            Row {
                width: parent.width; spacing: 10; visible: year.length > 0
                Label { text: qsTr("Year:"); font.bold: true }
                Label { text: year }
            }

            Row {
                width: parent.width; spacing: 10; visible: director.length > 0
                Label { id: directorLabel; text: qsTr("Director:"); font.bold: true }
                Label { text: director; width: parent.width - directorLabel.width - parent.spacing; wrapMode: Text.WordWrap }
            }

            Row {
                width: parent.width; spacing: 10; visible: tagline.length > 0
                Label { id: taglineLabel; text: qsTr("Tagline:"); font.bold: true }
                Label { text: tagline; width: parent.width - taglineLabel.width - parent.spacing; wrapMode: Text.WordWrap }
            }

            Row {
                width: parent.width; spacing: 10; visible: mpaa.length > 0
                Label { text: qsTr("MPAA:"); font.bold: true }
                Label { text: mpaa }
            }

            Row {
                width: parent.width; spacing: 10; visible: instrument.length > 0
                Label { text: qsTr("Instrument:"); font.bold: true }
                Label { text: instrument }
            }

            Row {
                width: parent.width; spacing: 10; visible: style.length > 0
                Label { id: styleLabel; text: qsTr("Style:"); font.bold: true }
                Label { text: model.style; width: parent.width - styleLabel.width - parent.spacing; wrapMode: Text.WordWrap }
            }

            Row {
                width: parent.width; spacing: 10; visible: mood.length > 0
                Label { id: moodLabel; text: qsTr("Mood:"); font.bold: true }
                Label { text: mood; width: parent.width - moodLabel.width - parent.spacing; wrapMode: Text.WordWrap }
            }

            Row {
                width: parent.width; spacing: 10; visible: born.length > 0
                Label { text: qsTr("Born:"); font.bold: true }
                Label { text: born }
            }

            Row {
                width: parent.width; spacing: 10; visible: formed.length > 0
                Label { text: qsTr("Formed:"); font.bold: true }
                Label { text: formed }
            }

            Row {
                width: parent.width; spacing: 10; visible: died.length > 0
                Label { text: qsTr("Died:"); font.bold: true }
                Label { text: died }
            }

            Row {
                width: parent.width; spacing: 10; visible: disbanded.length > 0
                Label { text: qsTr("Disbanded:"); font.bold: true }
                Label { text: disbanded }
            }

            Row {
                width: parent.width; spacing: 10; visible: duration.length > 0
                Label { text: qsTr("Duration:"); font.bold: true }
                Label { text: duration }
            }

            Row {
                width: parent.width; spacing: 10; visible: comment.length > 0
                Label { id: commentLabel; text: qsTr("Comment:"); font.bold: true }
                Label { text: comment; width: parent.width - commentLabel.width - parent.spacing; wrapMode: Text.WordWrap }
            }

            Row {
                width: parent.width; spacing: 10; visible: playcount.length > 0
                Label { text: qsTr("Playcount:"); font.bold: true }
                Label { text: playcount }
            }

            Row {
                width: parent.width; spacing: 10; visible: cast.length > 0
                Label { id: castLabel; text: qsTr("Cast:"); font.bold: true }
                Label { text: cast; width: parent.width - castLabel.width - parent.spacing; wrapMode: Text.WordWrap }
            }

            SectionHeader { width: parent.width }

            Label {
                id: plotLabel; width: parent.width; visible: plot.length > 0
                text: plot;
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
            Label {
                id: descriptionLabel; width: parent.width; visible: description.length > 0
                text: description;
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }

    }
    Loader {
        id: buttonLoader
        anchors.bottom: parent.bottom
        width: parent.width
        states: [
            State {
                name: "hidden"; when: !playable
                PropertyChanges { target: buttonLoader; visible: false; height: 0 }
            },
            State {
                name: "horizontal"; when: screen.currentOrientation === Screen.Landscape
                PropertyChanges { target: buttonLoader; sourceComponent: horizontalButtons }
            },
            State {
                name: "vertical"; when: screen.currentOrientation === Screen.Portrait
                PropertyChanges { target: buttonLoader; sourceComponent: verticalbuttons }
            }

        ]
        onStateChanged: print("loader state is now:", state, itemDetails.orientation)
    }

    Component {
        id: horizontalButtons
        ButtonRow {
            id: buttonRow
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: parent.width
            exclusive: false

            states: [
                State {
                    name: "hidden"; when: !playable
                    PropertyChanges { target: buttonRow; visible: false; height: 0 }
                }
            ]

            Button {
                text: qsTr("Play")
                onClicked: itemDetails.playItem()
            }
            Button {
                text: qsTr("Add to playlist")
                onClicked: itemDetails.addToPlaylist()
            }
            Button {
                text: qsTr("Download")
                onClicked: itemDetails.askDownload()
            }
        }
    }

    Component {
        id: verticalbuttons
        ButtonColumn {
            id: buttonColumn
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: parent.width
            exclusive: false

            Button {
                text: qsTr("Play")
                onClicked: itemDetails.playItem()
            }
            Button {
                text: qsTr("Add to playlist")
                onClicked: itemDetails.addToPlaylist()
            }
            Button {
                text: qsTr("Download")
                onClicked: itemDetails.askDownload()
            }
        }
    }

}
