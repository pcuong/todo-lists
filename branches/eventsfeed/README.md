ToDo Lists v1.1
===============

ToDo Lists is a Nokia Developer example application demonstrating how to use the Qt Quick
Components. ToDo Lists allows the user to maintain and track tasks in three
different categories, set due dates for the tasks, and sort the tasks.

This example application is hosted in Nokia Developer Projects:
- http://projects.developer.nokia.com/todolists

This example application demonstrates:
- Qt Quick Components
- A custom-implemented "list model" with sorting ability

For more information on implementation and porting, visit the project's wiki
pages:
- http://projects.developer.nokia.com/todolists/wiki


What's new
----------

Events Feed support on Harmattan platform to show due tasks on events feed.


1. Usage
-------------------------------------------------------------------------------

The application uses Qt Quick Components wherever possible. The tab-like
navigation is built using a TabGroup that holds PageStack elements.

The tasks list is a regular ListView that uses a custom TaskModel. The
TaskModel is implemented with Qt / C++ and it provides adding, removing and moving
list items in the model. The model also handles storing and loading
model data to files.

The DatePicker is a custom QML element for selecting the due
date. The dates are shown by updating the texts of the ListModel's items
when the user moves the view back and forth. This way the the DatePicker
gives an illusion of an "infinite" amount of dates performing very quickly.


2. Prerequisites
-------------------------------------------------------------------------------

 - Qt basics
 - Qt Quick basics


3. Project structure and implementation
-------------------------------------------------------------------------------

3.1 Folders
-----------

 |                    The root folder contains the licence information and this
 |                    file (release notes).
 |
 |- bin               Contains the compiled binaries.
 |
 |- doc               Contains documents and graphics projects that were used
 |                    during the development of the application.
 |
 |- src               Contains the project file of the application and Qt/C++
    |                 source code.
    |
    |- icons          Contains the application icons.
    |
    |- qml            Root folder for QML and JavaScript files.
    |  |
    |  |- common      Common, cross-platform QML and JavaScript files.
    |  |
    |  |- harmattan   MeeGo 1.2 Harmattan-specific QML and JavaScript files.
    |  |
    |  |- images      Graphics used in the QML files.
    |  |
    |  |- symbian     Symbian-specific QML and JavaScript files.
    |
    |- qtc_packaging  Contains the MeeGo 1.2 Harmattan (Debian) packaging files.


3.3 Used APIs/QML elements/Qt Quick Components
----------------------------------------------

The application uses the following Qt Quick Components' QML elements.

- Menu
- SelectionListItem
- TabBar
- TabGroup

The application uses a custom TaskModel to hold the task data. This
allows sorting task data and serialising data to the file.


4. Compatibility
-------------------------------------------------------------------------------

 - Symbian devices with Qt 4.7.4 or higher.

Tested to work on Nokia C7-00, Nokia N8-00, Nokia E6-00, and Nokia N9. Developed
with Qt SDK 1.2.

4.1 Required capabilities
-------------------------

None; the application can be self-signed on Symbian.


4.2 Known issues
----------------

None. 


5. Building, installing, and running the application
-------------------------------------------------------------------------------

5.1 Preparations
----------------

Check that you have the latest Qt SDK installed in the development environment
and the latest Qt version on the device.

Qt Quick Components 1.1 or higher is required.

5.2 Using the Qt SDK
--------------------

You can install and run the application on the device using the Qt SDK.
Open the project in the SDK, set up the correct target (depending on the device
platform), and click the Run button. For more details about this approach,
visit the Qt Getting Started section at Nokia Developer
(http://www.developer.nokia.com/Develop/Qt/Getting_started/).

5.3 Symbian device
------------------

Make sure your device is connected to your computer. Locate the .sis
installation file and open it with Ovi Suite. Accept all requests from Nokia
Suite and the device. Note that you can also install the application by copying
the installation file onto your device and opening it with the Symbian File
Manager application.

After the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.

5.4 Nokia N9 and Nokia N950
---------------------------

Copy the application Debian package onto the device. Locate the file with the
device and run it; this will install the application. Note that you can also
use the terminal application and install the application by typing the command
'dpkg -i todolists_v1_0_harmattan.deb' on the command line. To install the
application using the terminal application, make sure you have the right
privileges to do so (e.g. root access).

Once the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.


6. Licence
-------------------------------------------------------------------------------

See the licence text file delivered with this project. The licence file is also
available online at
- http://projects.developer.nokia.com/todolists/browser/Licence.txt


7. Related documentation
-------------------------------------------------------------------------------
Qt Quick Components
- http://doc.qt.nokia.com/qt-components-symbian-1.0/index.html
- http://harmattan-dev.nokia.com/docs/library/html/qt-components/qt-components.html


8. Version history
-------------------------------------------------------------------------------
1.1 Support for Events Feed API on Harmattan.
1.0 Initial version.
