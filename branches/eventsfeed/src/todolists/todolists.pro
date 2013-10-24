# Copyright (c) 2012 Nokia Corporation.

QT += declarative
CONFIG += qt-components

VERSION = 1.1

HEADERS += \
    qmlloader.h \
    taskdata.h \
    taskmodel.h \
    qthelper.h

SOURCES += \
    main.cpp \
    qmlloader.cpp \
    taskdata.cpp \
    taskmodel.cpp \
    qthelper.cpp

symbian {
    TARGET = ToDoLists
    TARGET.UID3 = 0xE55B8D2E

    TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x1000 0x1800000 # 24MB

    # To lock the application to portrait orientation
    LIBS += -lcone -leikcore -lavkon

    ICON = icons/todolists.svg

    # Deploy the symbian qml files
    qmlfiles.sources = qml/common qml/symbian qml/images
    qmlfiles.path = qml

    # Backup and restore functionality
    backup.sources = backup_registration.xml
    backup.path = !:/private/E55B8D2E

    DEPLOYMENT += qmlfiles backup
}


simulator {
    CONFIG(debug, debug|release) {
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug\\qml)
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug\\qml\\common)
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug\\qml\\symbian)
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug\\qml\\images)
        system(copy .\\qml\\common\\* ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug\\qml\\common)
        system(copy .\\qml\\symbian\\* ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug\\qml\\symbian)
        system(copy .\\qml\\images\\* ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug\\qml\\images)
    }
    else {
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Release\\qml)
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Release\\qml\\common)
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Release\\qml\\symbian)
        system(mkdir ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Release\\qml\\images)
        system(copy .\\qml\\common\\* ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Release\\qml\\common)
        system(copy .\\qml\\symbian\\* ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Release\\qml\\symbian)
        system(copy .\\qml\\images\\* ..\\todolists-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Release\\qml\\images)
    }
}


contains(MEEGO_EDITION, harmattan) {
    DEFINES += Q_WS_HARMATTAN

    INCLUDEPATH += \
        /usr/include/gq #For the GConf

    # Speed up launching on MeeGo / Harmattan when using applauncher daemon
    CONFIG += qdeclarative-boostable

    # For the #include <meventfeed.h>
    CONFIG += meegotouchevents

    # GConf lib
    LIBS += -lgq-gconf

    HEADERS += ../todolists-events-feed-client/feedupdater.h
    SOURCES += ../todolists-events-feed-client/feedupdater.cpp

    target.path = /opt/todolists/bin

    qml.files = qml/common qml/harmattan qml/images
    qml.path = /opt/todolists/qml

    desktopfile.files = ../qtc_packaging/debian_harmattan/todolists.desktop
    desktopfile.path = /usr/share/applications

    icon.files = icons/todolists80x80.png
    icon.path = /usr/share/icons/hicolor/80x80/apps

    INSTALLS += \
        target \
        qml \
        desktopfile \
        icon
}
