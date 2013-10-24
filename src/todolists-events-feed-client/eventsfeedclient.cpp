/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include "eventsfeedclient.h"

#include <QtCore>
#include <libsyncpluginmgr/PluginCbInterface.h>
#include "feedupdater.h"


/*!
  \class Eventsfeedclient
  \brief Implements the SyncFW API to provide timed syncronisation for the
         ToDo Lists tasks to Events Feed.
*/


/*!
  Function to create EventsFeedClient, called by the SyncFW.
*/
extern "C" EventsFeedClient* createPlugin(const QString& pluginName,
                                          const Buteo::SyncProfile& profile,
                                          Buteo::PluginCbInterface *cbInterface)
{
    return new EventsFeedClient(pluginName, profile, cbInterface);
}


/*!
  Function to destroy the EventsFeedClient, called by the SyncFW.
*/
extern "C" void destroyPlugin(EventsFeedClient *client)
{
    delete client;
}


/*!
  Constructor.
*/
EventsFeedClient::EventsFeedClient(const QString& pluginName,
                                   const Buteo::SyncProfile& profile,
                                   Buteo::PluginCbInterface *cbInterface)
    : ClientPlugin(pluginName, profile, cbInterface)
{
}


/*!
  Destructor.
*/
EventsFeedClient::~EventsFeedClient()
{
}


/*!
  Called by the SyncFW right after the createPlugin.
*/
bool EventsFeedClient::init()
{
    // The sync profiles can have some specific key / value pairs, this info
    // can be accessed by this method.
    m_properties = iProfile.allNonStorageKeys();

    return true;
}


/*!
  Called before unloading the plugin, the plugin should clean up here.
*/
bool EventsFeedClient::uninit()
{
    return true;
}


/*!
  Called when the Events feed should be updated. The init is called before
  this method is called. Method is expected to return either true or false
  based on if the sync was started succesfully or it failed for some reason.
  The syncSuccess or syncFailed signals should be emitted based on the
  status of the operation success / failed.

  Method queries the status of GConfItem in order to find out if the
  ToDo Lists due tasks should be added to the feed.
*/
bool EventsFeedClient::startSync()
{
    FeedUpdater feedUpdater;
    FeedUpdater::UPDATE_RESULT result = feedUpdater.updateFeed();

    if (result == FeedUpdater::SUCCESS) {
        m_results = Buteo::SyncResults(QDateTime::currentDateTime(),
                                       Buteo::SyncResults::SYNC_RESULT_SUCCESS,
                                       Buteo::SyncResults::NO_ERROR);
        m_results.setScheduled(true);

        // Notify SyncFW of result.
        emit success(getProfileName(), "Success!!");

        return true;
    }
    else if (result == FeedUpdater::FAILED) {
        m_results = Buteo::SyncResults(QDateTime::currentDateTime(),
                    Buteo::SyncResults::SYNC_RESULT_FAILED,
                    Buteo::SyncResults::ABORTED);
        m_results.setScheduled(true);

        // Notify Sync FW of result.
        emit error(getProfileName(), "Error!!",
                   Buteo::SyncResults::SYNC_RESULT_FAILED);

        return false;
    }

    return true;
}


/*!
  This method is called if used cancels the sync in between, with the applet
  use case it should not ideally happen as there is no UI in case of device
  sync and accounts sync we have a cancel button.
*/
void EventsFeedClient::abortSync(Sync::SyncStatus status)
{
    Q_UNUSED(status);
}


/*!
  This method is called when the client is removed / uninstalled from the
  system eg. when the ToDo Lists is uninstalled.
*/
bool EventsFeedClient::cleanUp()
{
    return true;
}


/*!
  Returns the results of the sync.
*/
Buteo::SyncResults EventsFeedClient::getSyncResults() const
{
    return m_results;
}


/*!
  Reports the changed state in connectivity.
*/
void EventsFeedClient::connectivityStateChanged(Sync::ConnectivityType type,
                                                bool state)
{
    Q_UNUSED(type);
    Q_UNUSED(state);
}
