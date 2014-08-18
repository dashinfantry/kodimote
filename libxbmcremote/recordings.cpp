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

#include "recordings.h"

#include "xbmc.h"
#include "xbmcconnection.h"
//#include "channelitem.h"
#include "videoplaylistitem.h"
#include "libraryitem.h"
#include "videoplayer.h"
#include "playlist.h"

Recordings::Recordings(const QString &path, bool allSubItems, XbmcModel *parent) :
    XbmcLibrary(parent),
    m_path(path),
    m_allSubItems(allSubItems)
{
}

QString Recordings::title() const
{
    return m_path.isEmpty() ? tr("Recordings") : m_path.split("/").last();
}

void Recordings::refresh()
{
    QVariantMap params;
    QVariantList properties;

//    properties.append("art");
    properties.append("channel");
    properties.append("directory");
//    properties.append("endtime");
    properties.append("file");
//    properties.append("genre");
    properties.append("icon");
//    properties.append("lifetime");
    properties.append("playcount");
    properties.append("plot");
//    properties.append("plotoutline");
//    properties.append("recordingid");
//    properties.append("resume");
//    properties.append("runtime");
    properties.append("starttime");
//    properties.append("streamurl");
    properties.append("title");


    params.insert("properties", properties);

    XbmcConnection::sendCommand("PVR.GetRecordings", params, this, "listReceived");
}

XbmcModel *Recordings::enterItem(int index)
{
    XbmcModelItem *item = m_list.at(index);

    if (item->property("isAllItem").toBool()) {
        return new Recordings(m_path, true, this);
    }

    QString path = m_path;
    if (!path.isEmpty()) {
        path.append("/");
    }
    path.append(item->title());
    return new Recordings(path, false, this);

}

void Recordings::playItem(int index)
{
    Xbmc::instance()->videoPlayer()->playlist()->clear();

    // FIXME: Playlist.Add() doesn't seem to support recordingid yet. We need to use the file mechanism for now.
//    VideoPlaylistItem item;
//    qDebug() << "setting recid" << m_list.at(index)->data(RoleRecordingId).toInt();
//    item.setRecordingId(m_list.at(index)->data(RoleRecordingId).toInt());
//    Xbmc::instance()->videoPlayer()->playlist()->addItems(item);

    Xbmc::instance()->videoPlayer()->playlist()->addFile(m_list.at(index)->data(RoleFileName).toString());

    Xbmc::instance()->videoPlayer()->playItem(0);
}

void Recordings::addToPlaylist(int index)
{
    Q_UNUSED(index);
}

QHash<int, QByteArray> Recordings::roleNames() const
{
    QHash<int, QByteArray> roles = XbmcLibrary::roleNames();
    roles.insert(Qt::UserRole + 2000, "progressPercentage");
    return roles;
}

void Recordings::fetchItemDetails(int index)
{
}

void Recordings::listReceived(const QVariantMap &rsp)
{
    setBusy(false);
    QList<XbmcModelItem*> list;
    QVariantList responseList = rsp.value("result").toMap().value("recordings").toList();
    QHash<QString, LibraryItem*> paths;
    foreach(const QVariant &itemVariant, responseList) {
        QVariantMap itemMap = itemVariant.toMap();
        QString fullPath = itemMap.value("directory").toString();
        fullPath = fullPath.remove(QRegExp("^/"));
        // Filter away everything outside this path
        if (!fullPath.startsWith(m_path)) {
            continue;
        }

        // Group everything in subpaths
        if (!m_allSubItems && fullPath != m_path) {
            QString relPath = fullPath;
            relPath.remove(QRegExp("^" + m_path + "/?"));

            QString folder = relPath;
            folder = folder.split('/').first();

            qDebug() << "got path" << fullPath << m_path << relPath << folder;

            if (paths.contains(folder)) {
                // Already have this subfolder
                LibraryItem *item = paths.value(folder);
                item->setProperty("childCount", item->property("childCount").toInt() + 1);
                item->setSubtitle(tr("%1 recordings").arg(item->property("childCount").toInt()));
                if (item->playcount() > 0 && itemMap.value("playcount").toInt() == 0) {
                    item->setPlaycount(0);
                }
                continue;
            }

            LibraryItem *item = new LibraryItem(folder, "", this);
            item->setProperty("childCount", 1);
            item->setThumbnail(itemMap.value("icon").toString());
//            item->setThumbnail(itemMap.value("art").toMap().value("thumb").toString());
            item->setSubtitle(tr("%1 recordings").arg(1));
            item->setPlaycount(itemMap.value("playcount").toInt());
            paths.insert(folder, item);
            list.append(item);
            continue;
        }


        LibraryItem *item = new LibraryItem(itemMap.value("title").toString(), " ", this);
        item->setRecordingId(itemMap.value("recordingid").toInt());
        item->setFileType("file");
        item->setPlayable(true);
        item->setFileName(itemMap.value("file").toString());

        QDateTime startTime = itemMap.value("starttime").toDateTime();
        QString channel = itemMap.value("channel").toString().remove(QRegExp("[#0-9]* "));
        item->setSubtitle(startTime.toString(Qt::SystemLocaleShortDate) + " (" + channel + ")");
        item->setThumbnail(itemMap.value("icon").toString());
        item->setFanart(itemMap.value("art").toMap().value("thumb").toString());
        item->setPlot(itemMap.value("plot").toString());

        item->setPlaycount(itemMap.value("playcount").toInt());
        list.append(item);
    }

    if (paths.count() > 0) {
        LibraryItem *allItem = new LibraryItem(tr("All recordings"), "", this);
        allItem->setProperty("isAllItem", true);
        list.prepend(allItem);
    }

    beginInsertRows(QModelIndex(), 0, list.count() - 1);
    foreach(XbmcModelItem *item, list) {
        m_list.append(item);
    }
    endInsertRows();
}
