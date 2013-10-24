/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef EVENTSFEEDCLIENT_H
#define EVENTSFEEDCLIENT_H

#include <libsyncpluginmgr/ClientPlugin.h>
#include <libsyncprofile/SyncResults.h>


class EventsFeedClient : public Buteo::ClientPlugin {
    Q_OBJECT

public:
    EventsFeedClient(const QString& pluginName,
                     const Buteo::SyncProfile& profile,
                     Buteo::PluginCbInterface *cbInterface);
    virtual ~EventsFeedClient();

    virtual bool init();
    virtual bool uninit();
    virtual bool startSync();
    virtual void abortSync(Sync::SyncStatus status = Sync::SYNC_ABORTED);
    virtual Buteo::SyncResults getSyncResults() const;
    virtual bool cleanUp();

public slots:
    virtual void connectivityStateChanged(Sync::ConnectivityType type,
                                          bool state );

private:
    void updateResults(const Buteo::SyncResults &results);

private:
    QMap<QString, QString> m_properties;
    Buteo::SyncResults m_results;
};

extern "C" EventsFeedClient* createPlugin(const QString& pluginName,
                                          const Buteo::SyncProfile& profile,
                                          Buteo::PluginCbInterface *cbInterface);

extern "C" void destroyPlugin(EventsFeedClient *client);

#endif // EVENTSFEEDCLIENT_H
