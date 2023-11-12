import QtQuick 2.0
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
  
    property alias cfg_textOverIcon: textOverIcon.checked

    QQC2.CheckBox {
        id: textOverIcon
        text: i18n("Percent over icon")
        onCheckedChanged: {
          console.log("--> CHANGED!")
          console.log("... cfg_textOverIcon: " + cfg_textOverIcon)
        }
    }
}
