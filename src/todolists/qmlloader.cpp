/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include "qmlloader.h"

#include <QtDeclarative>

#include "qthelper.h"
#include "taskmodel.h"

// Lock orientation in Symbian
#ifdef Q_OS_SYMBIAN
    #include <eikenv.h>
    #include <eikappui.h>
    #include <aknenv.h>
    #include <aknappui.h>
#endif


/*!
  \class QMLLoader
  \brief Handles the loading of the splash screen and the main qml.
*/


/*!
  Constructor.
*/
QMLLoader::QMLLoader(QDeclarativeView *view)
    : m_View(view)
{
}


/*!
  Loads splash screen, also connects the splash screens hidden signal to this
  objects destroySplashScreen slot, so when the splash screen has animated
  away it will be destroyed.
*/
void QMLLoader::loadSplashScreen()
{
#ifdef Q_OS_SYMBIAN
    // Lock orientation in Symbian for the splash screen
    CAknAppUi* appUi =
            dynamic_cast<CAknAppUi*> (CEikonEnv::Static()->AppUi());
    TRAP_IGNORE(
        if (appUi) {
            appUi->SetOrientationL(CAknAppUi::EAppUiOrientationPortrait);
        }
    );
#endif

    QString splashQmlFile = "qml/symbian/SplashScreen.qml";

    QDeclarativeComponent splashComponent(m_View->engine(),
                                          QUrl::fromLocalFile(splashQmlFile));

    m_SplashItem = qobject_cast<QDeclarativeItem *>(splashComponent.create());

    m_SplashItem->setWidth(m_View->width());
    m_SplashItem->setHeight(m_View->height());

    connect(m_SplashItem, SIGNAL(hidden()), this, SLOT(destroySplashScreen()),
            Qt::QueuedConnection);

    m_View->scene()->addItem(m_SplashItem);
}


/*!
  Loads the main QML file while the splash screen is being shown.
*/
void QMLLoader::loadMainQML()
{
    qmlRegisterType<QtHelper>("CustomElements", 1, 0, "QtHelper");
    qmlRegisterType<TaskModel>("CustomElements", 1, 0, "TaskModel");

#if defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    QString mainQmlFile = "qml/symbian/Main.qml";
#else
    QString mainQmlFile =
            qApp->applicationDirPath() + "/../qml/harmattan/Main.qml";
#endif

    QDeclarativeComponent component(m_View->engine(),
                                    QUrl::fromLocalFile(mainQmlFile));

    if (component.status() == QDeclarativeComponent::Error) {
        qDebug() << "Error(s): " << component.errors();
        return;
    }

    m_MainItem = qobject_cast<QDeclarativeItem*>(component.create());

    if (m_MainItem == NULL) {
        qDebug() << "MainItem is NULL";
        return;
    }

    m_View->scene()->addItem(m_MainItem);

    // Framework connections
    connect((QObject*)m_View->engine(), SIGNAL(quit()),
            qApp, SLOT(quit()));

#if defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    // Begin the hide animation of the splash screen
    QMetaObject::invokeMethod(m_SplashItem, "startHideAnimation");
#endif
}


/*!
  Destroys the splash screen.
*/
void QMLLoader::destroySplashScreen()
{
    m_View->scene()->removeItem(m_SplashItem);
    delete m_SplashItem;
    m_SplashItem = 0;

#ifdef Q_OS_SYMBIAN
    // Release the portrait lock on Symbian
    CAknAppUi* appUi =
            dynamic_cast<CAknAppUi*> (CEikonEnv::Static()->AppUi());
    TRAP_IGNORE(
        if (appUi) {
            appUi->SetOrientationL(CAknAppUi::EAppUiOrientationUnspecified);
        }
    );
#endif
}
