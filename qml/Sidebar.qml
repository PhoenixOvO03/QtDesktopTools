
import QtQuick

ListView{
    property int pageIndex: -1
    property string theme: "dark"
    property ListModel sideItems: ListModel{
        ListElement{imageName: "key"}
        ListElement{imageName: "web"}
        ListElement{imageName: "skin"}
    }

    id: root
    height: 50
    clip: true
    interactive: false // 禁止滑动
    orientation: ListView.Horizontal
    currentIndex: root.pageIndex
    model: sideItems

    delegate: Image{
        width: 50
        height: 50
        source: "qrc:res/" + imageName + (root.theme === "dark" ? ".png" : "_black.png")

        MouseArea{
            anchors.fill: parent
            onClicked: root.pageIndex = index
        }
    }

    highlight: Rectangle{
        color: root.theme === "dark" ? "#20ffffff" : "#20000000"
    }
}
