/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include "qthelper.h"

#include <QtCore>
#include <qdeclarative.h>

#ifdef Q_WS_HARMATTAN
// For Swipe lock
#include <QApplication>
#include <QWidget>
#include <QX11Info>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#endif


/*!
  \class QtHelper
  \brief Class to help date calculation and saving / loading settings in QML.
         Also handles the applying of swipe lock on Harmattan.
*/


/*!
  Constructor.
*/
QtHelper::QtHelper(QObject *parent) :
    QObject(parent)
{
    m_Settings = new QSettings("Nokia", "ToDoLists", this);
}


/*!
  Returns amount of days from today to the given date.
*/
int QtHelper::daysFromToday(const QDateTime &date) const
{
    return QDate::currentDate().daysTo(date.date());
}


/*!
  Adds count of days to the given date and returns the added date.
  This function can be called from QML.
*/
QDateTime QtHelper::sumDates(const QDateTime &date, int addDays) const
{
    return date.addDays(addDays);
}


/*!
  Returns the date in human readable format.
*/
QString QtHelper::dateString(const QDateTime &date) const
{
    int days = daysFromToday(date);
    QString theseDays;

    if (days == 0) {
        theseDays = " (Today)";
    }
    else if (days == 1) {
        theseDays = " (Tomorrow)";
    }

    QLocale locale = QLocale(QLocale::English);
    return locale.toString(date, "MMM. d, dddd") + theseDays;
}


/*!
  Saves a given key - value setting by using QSetting to devices persistent
  storage.
*/
void QtHelper::saveSetting(const QVariant &key, const QVariant &value)
{
    m_Settings->setValue(key.toString(), value);
}


/*!
  Loads setting from the devices persistent storage, the key defines the
  setting to load, defaultValue is the value for the key if the value
  not yet exist in the persistent storage.
*/
QVariant QtHelper::loadSetting(const QVariant &key,
                               const QVariant &defaultValue)
{
    return m_Settings->value(key.toString(), defaultValue);
}


/*!
  Enables / disables the Swipe of the Harmattan. This is used on sorting mode
  when the user can drag item over the edge of the UI.
*/
void QtHelper::enableSwipe(bool enable)
{
#ifdef Q_WS_HARMATTAN
    QWidget *activeWindow = QApplication::activeWindow();
    Display *dpy = QX11Info::display();
    Atom atom;

    if (!activeWindow) {
        return;
    }

    atom = XInternAtom(dpy, "_MEEGOTOUCH_CUSTOM_REGION", False);

    if (enable) {
        XDeleteProperty(dpy, activeWindow->effectiveWinId(), atom);
    }
    else {
        unsigned int customRegion[] =
        {
            activeWindow->x(),
            activeWindow->y(),
            activeWindow->width(),
            activeWindow->height()
        };

        XChangeProperty(dpy, activeWindow->winId(), atom,
                        XA_CARDINAL, 32, PropModeReplace,
                        reinterpret_cast<unsigned char*>(&customRegion[0]), 4);
    }
    #endif
}

QML_DECLARE_TYPE(QtHelper)
