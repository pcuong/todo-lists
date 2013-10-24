# Copyright (c) 2012 Nokia Corporation.

TEMPLATE = lib
VERSION = 1.1

contains(MEEGO_EDITION, harmattan) {
    TARGET = todolists-events-feed-client
    DEPENDPATH += ./
    INCLUDEPATH += . \
        /usr/include/libsynccommon \
        /usr/include/libsyncprofile \
        /usr/include/gq \
        ../todolists

    LIBS += -lsyncpluginmgr -lsyncprofile -lgq-gconf

    CONFIG += debug plugin meegotouchevents
    QT -= gui

    SOURCES += \
        ../todolists/taskdata.cpp \
        eventsfeedclient.cpp \
        feedupdater.cpp

    HEADERS += \
        ../todolists/taskdata.h \
        eventsfeedclient.h \
        feedupdater.h

    OTHER_FILES += \
        xml/todolists-events-feed.xml \
        xml/service/todolists-events-feed.xml \
        xml/sync/todolists-events-feed.xml \
        settings/todolists-feeds-settings.xml \
        settings/todolists-settings.desktop

    QMAKE_CXXFLAGS = -Wall \
        -g \
        -Wno-cast-align \
        -O2 -finline-functions

    target.path = /usr/lib/sync/

    client.path = /etc/sync/profiles/client
    client.files = $$PWD/xml/todolists-events-feed.xml

    sync.path = /etc/sync/profiles/sync
    sync.files = $$PWD/xml/sync/*

    service.path = /etc/sync/profiles/service
    service.files = $$PWD/xml/service/*

    settingsdesktop.path = /usr/share/duicontrolpanel/desktops
    settingsdesktop.files = $$PWD/settings/todolists-settings.desktop

    settingsxml.path = /usr/share/duicontrolpanel/uidescriptions
    settingsxml.files = $$PWD/settings/todolists-feeds-settings.xml

    INSTALLS += target client sync service settingsdesktop settingsxml
}
