/*****************************************************************************
 * Copyright: 2011-2013 Michael Zanetti <michael_zanetti@gmx.net>            *
 *                                                                           *
 * This file is part of Kodimote                                           *
 *                                                                           *
 * Kodimote is free software: you can redistribute it and/or modify        *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation, either version 3 of the License, or         *
 * (at your option) any later version.                                       *
 *                                                                           *
 * Kodimote is distributed in the hope that it will be useful,             *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 * GNU General Public License for more details.                              *
 *                                                                           *
 * You should have received a copy of the GNU General Public License         *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.     *
 *                                                                           *
 ****************************************************************************/

#ifndef FILES_H
#define FILES_H

#include "kodilibrary.h"

class Files : public KodiLibrary
{
    Q_OBJECT
public:
    explicit Files(const QString &mediaType, const QString &dir, KodiModel *parent = 0);

    KodiModel *enterItem(int index);
    void playItem(int index);
    void addToPlaylist(int index);

    QString title() const;
    Q_INVOKABLE void download(int index, const QString &path);

public slots:
    void refresh();

private slots:
    void listReceived(const QVariantMap &rsp);

protected:
    QString m_mediaType;
    QString m_dir;
    bool m_sort;

    virtual QString parseTitle(const QString &title) const;
    virtual bool filterFile(const QVariantMap &item) const;
};

#endif // FILES_H
