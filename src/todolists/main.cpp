/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include <QtGui>
#include <QtDeclarative>
#include "qmlloader.h"


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QDeclarativeView view;
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view.setAutoFillBackground(false);

    QMLLoader qmlLoader(&view);

#if defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    qmlLoader.loadSplashScreen();
#endif

    QTimer::singleShot(0, &qmlLoader, SLOT(loadMainQML()));

#if defined(Q_WS_HARMATTAN) || defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    view.setGeometry(QApplication::desktop()->screenGeometry());
    view.showFullScreen();
#else
    view.setGeometry(QRect(100, 100, 360, 640));
    view.show();
#endif

    return app.exec();
}
