
import QtQuick
import QtQuick.Shapes

Shape {
    property color topLeft: "#456EA6"
    property color bottomRight: "#8A5A91"

    id: root

    ShapePath { // 方形渐变背景
        strokeWidth: -1
        fillGradient: LinearGradient {
            x1: 0; y1: 0
            x2: root.width; y2: root.height
            GradientStop { position: 0; color: topLeft }
            GradientStop { position: 1; color: bottomRight }
        }
        startX: 0; startY: 0
        PathLine { x: root.width; y: 0 }
        PathLine { x: root.width; y: root.height }
        PathLine { x: 0; y: root.height }
        PathLine { x: 0; y: 0 }
    }
}