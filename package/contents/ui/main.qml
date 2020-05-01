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
    connectedSources: [batteryKey, acAdapterKey]
    interval: 1000
    onSourceAdded: {
      console.log("[DEBUG] - onSourceAdded")
      disconnectSource(source)
      connectSource(source)
    }
    onSourceRemoved: {
      console.log("[DEBUG] - onSourceAdded")
      disconnectSource(source)
    }
    onNewData: {
      console.log("[DEBUG] - onNewData")
    }
  }

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

  // Component.onCompleted: {
  //   console.log("[DEBUG] - onCompleted")
  //   myLog()
  // }

  Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

  Plasmoid.fullRepresentation: Item {
    Layout.minimumWidth: units.iconSizes.medium * 5
    // Layout.minimumHeight: units.gridUnit * 15

    property bool isOnBattery: pmSource.data[acAdapterKey][acPluggedKey] == false
    property int batteryPercent: pmSource.data[batteryKey][batteryPercentKey]

    RowLayout {
      anchors.fill: parent

      Image {
        Layout.leftMargin: 10
        Layout.preferredWidth: 75
        Layout.preferredHeight: 75
        smooth: true
        fillMode: Image.PreserveAspectFit
        source: chooseBatteryIcon()
      }

      PlasmaComponents.Label {
        text: prettyPrintPercent()
        font.pixelSize: 25
        Layout.rightMargin: 10
      }
    }

    function prettyPrintPercent() {
      return batteryPercent + " %"
    }

    function chooseBatteryIcon() {
      var iconName = "battery_100"
      if (!isOnBattery) {
        iconName = "battery_charging"
      } else if (batteryPercent > 60) {
        iconName = "battery_80"
      } else if (batteryPercent > 40) {
        iconName = "battery_60"
      } else if (batteryPercent > 20) {
        iconName = "battery_40"
      } else {
        iconName = "battery_20"
      }
      return "../icons/" + iconName + ".png"
    }
  }
}