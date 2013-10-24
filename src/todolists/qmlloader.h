/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef QMLLOADER_H
#define QMLLOADER_H

#include <QObject>

class QDeclarativeItem;
class QDeclarativeView;

class QMLLoader : public QObject
{
    Q_OBJECT

public:
    QMLLoader(QDeclarativeView *view);

public:
    void loadSplashScreen();

public slots:
    void loadMainQML();
    void destroySplashScreen();

protected:
    QDeclarativeView *m_View; // Not owned
    QDeclarativeItem *m_SplashItem; // Not owned
    QDeclarativeItem *m_MainItem; // Not owned
};

#endif // QMLLOADER_H
