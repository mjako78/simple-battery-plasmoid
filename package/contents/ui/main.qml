import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
  id: main

  // Common used keys
  readonly property string batteryKey: "Battery"
  readonly property string batteryStateKey: "State"
  readonly property string batteryPercentKey: "Percent"
  readonly property string acAdapterKey: "AC Adapter"
  readonly property string acPluggedKey: "Plugged in"

  // DataSource
  property QtObject pmSource: PlasmaCore.DataSource {
    id: pmSource
    engine: "powermanagement"
    // connectedSources: sources
    // Get sources only for Battery and AC Adapter
    connectedSources: [batteryKey, acAdapterKey]
    interval: 1000
    // onSourceAdded: {
    //   console.log("[DEBUG] - onSourceAdded - ", source)
    //   disconnectSource(source)
    //   connectSource(source)
    // }
    // onSourceRemoved: {
    //   console.log("[DEBUG] - onSourceRemoved - ", source)
    //   disconnectSource(source)
    // }
    // onDataChanged: {
    //   console.log("[DEBUG] - onDataChanged")
    // }
    onNewData: {
      console.log("[DEBUG] - onNewData")
    }
  }

  // DataModel
  //  property QtObject batteries: PlasmaCore.DataModel {
  //   id: batteries
  //   dataSource: pmSource
  //   sourceFilter: "Battery[0-9]+"
  // }
  
  function myLog() {
    console.log("*** LOGGING PM_SOURCE ***")
		for (var i = 0; i < pmSource.sources.length; i++) {
			var sourceName = pmSource.sources[i]
			var source = pmSource.data[sourceName]
			for (var key in source) {
				console.log('pmSource.data["'+sourceName+'"]["'+key+'"] =', source[key])
			}
		}
	}

  Component.onCompleted: {
    console.log("[DEBUG] - onCompleted")
    myLog()
  }

  Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

  Plasmoid.fullRepresentation: Item {
    Layout.minimumWidth: units.iconSizes.medium * 9
    // Layout.minimumHeight: units.gridUnit * 15

    property bool isOnBattery: pmSource.data[acAdapterKey][acPluggedKey] == false
    property int batteryPercent: pmSource.data[batteryKey][batteryPercentKey]

    ColumnLayout {
      spacing: 2

      Text {
        text: "SIMPLE BATTERY MONITOR"
        color: theme.textColor
        font.pixelSize: height
      }

      PlasmaComponents.Label {
        text: "IsOnBattery: " + isOnBattery
      }

      PlasmaComponents.Label {
        text: "BatteryPercent: " + batteryPercent + "%"
      }
    }
  }
}