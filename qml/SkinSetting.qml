
import QtQuick
import QtQuick.Shapes

GridView{
    property string theme: "dark"

    id: root
    clip: true
    cellWidth: width / 4 - 6
    cellHeight: cellWidth

    model: ListModel{
        ListElement{ leftLight: "#FFF3FF"; rightLight: "#D8EAFF"; leftDark: "#604962"; rightDark: "#0C1824" }
        ListElement{ leftLight: "#F2F2F2"; rightLight: "#F2F2F2"; leftDark: "#111111"; rightDark: "#111111" }
        ListElement{ leftLight: "#D0F3FF"; rightLight: "#FEFEFF"; leftDark: "#628D9B"; rightDark: "#82AFC2" }
        ListElement{ leftLight: "#FFDDEF"; rightLight: "#F4FEE7"; leftDark: "#85707A"; rightDark: "#798967" }
        ListElement{ leftLight: "#F7CEC5"; rightLight: "#B4EAB2"; leftDark: "#776E78"; rightDark: "#597171" }
        ListElement{ leftLight: "#82E8A3"; rightLight: "#B6FAB7"; leftDark: "#5EB57D"; rightDark: "#6A9377" }
        ListElement{ leftLight: "#EEC0A2"; rightLight: "#FFE9B3"; leftDark: "#E9A276"; rightDark: "#F68F64" }
        ListElement{ leftLight: "#FFDF92"; rightLight: "#EFE5F9"; leftDark: "#735C16"; rightDark: "#38323F" }
        ListElement{ leftLight: "#A8F688"; rightLight: "#FBFBF7"; leftDark: "#3F612F"; rightDark: "#4F3242" }
        ListElement{ leftLight: "#DDD7FD"; rightLight: "#BDF9B2"; leftDark: "#4A4873"; rightDark: "#2A4129" }
        ListElement{ leftLight: "#FCC9F0"; rightLight: "#4DFCF3"; leftDark: "#653E61"; rightDark: "#174241" }
        ListElement{ leftLight: "#B2D4FE"; rightLight: "#E8C5F5"; leftDark: "#456EA6"; rightDark: "#8A5A91" }
    }

    delegate: Shape {
        width: root.width / 4 - 26
        height: width
        ShapePath {
            strokeWidth: -1 // 不描边
            fillGradient: LinearGradient {
                x1: 0; y1: 0
                x2: width; y2: height
                GradientStop { position: 0; color: root.theme === "dark" ? leftDark : leftLight }
                GradientStop { position: 1; color: root.theme === "dark" ? rightDark : rightLight }
            }
            startX: 0; startY: 0
            PathLine { x: width; y: 0 }
            PathLine { x: width; y: height }
            PathLine { x: 0; y: height }
            PathLine { x: 0; y: 0 }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: root.currentIndex = index
        }
    }

    highlight: Rectangle{
        color: "transparent"
        border.color: root.theme === "dark" ? "white" : "black"
        border.width: 10
        z: skinSetting.z + 2

        Text{
            anchors.centerIn: parent
            font.pixelSize: parent.width / 8
            text: "当前主题"
            color: root.theme === "dark" ? "white" : "black"
        }
    }
}