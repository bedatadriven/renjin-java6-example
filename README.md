
Renjin Certified Release Java 6 Example
=======================================


This is an example of using the Java 6 build of the latest
Renjin Certified Release.

**EXPERIMENTAL**

## Set up

To run, you must include your credentials for the
Nexus Repository for the Java 1.6 build of the Certified Release 3.4
in your Maven settings.xml file:

```.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                  https://maven.apache.org/xsd/settings-1.0.0.xsd">
<localRepository/>
<interactiveMode/>
<usePluginRegistry/>
<offline/>
<pluginGroups/>
<servers>
    <server>
        <id>renjin-certified</id>
        <username>YOUR_USERNAME</username>
        <password>YOUR_PASSWORD</password>
    </server>
</servers>
<mirrors/>
<proxies/>
<profiles/>
<activeProfiles/>
</settings>
```

