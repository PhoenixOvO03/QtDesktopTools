import QtQuick

Rectangle {
    property var showKeyObject: null
    property color backgroundColor: "#80808080"
    property color keyColor: "#80C0C0C0"
    property color textColor: "black"
    property int colorIndex: 0

    id: root
    color: "#c0444444"

    function setShowKeyObjectStyle(){
        if (root.showKeyObject !== null)
            root.showKeyObject.setStyle(root.backgroundColor, root.keyColor, root.textColor)
    }

    Column{
        spacing: 20

        Row{
            spacing: 20

            Rectangle{ // 按键预览及启动关闭
                property bool isOpen: false

                id: startRect
                width: 100
                height: 100
                visible: true
                radius: 25
                color: root.backgroundColor

                Rectangle{
                    width: 80
                    height: 80
                    radius: 25
                    anchors.centerIn: parent
                    color: root.keyColor
                    visible: true

                    Text {
                        text: startRect.isOpen ? "关闭" : "打开"
                        anchors.centerIn: parent
                        color: root.textColor
                        font.pixelSize: 20
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (startRect.isOpen){
                            root.showKeyObject.destroy()
                            root.showKeyObject = null
                        }else{
                            var component = Qt.createComponent("qrc:/qml/ShowPressedKey.qml");
                            var object = component.createObject();
                            root.showKeyObject = object
                            root.setShowKeyObjectStyle()
                            object.show()
                        }
                        startRect.isOpen = !startRect.isOpen
                    }
                }
            }

            CheckBtn{
                id: backBtn
                anchors.bottom: parent.bottom
                width: 100
                height: 50
                labelText: "背景"
                isChecked: true
                onIsCheckedChanged: {
                    if (isChecked){
                        keyBtn.isChecked = false
                        textBtn.isChecked = false
                        root.colorIndex = 0
                    }
                }
            }
            CheckBtn{
                id: keyBtn
                anchors.bottom: parent.bottom
                width: 100
                height: 50
                labelText: "按键"
                onIsCheckedChanged: {
                    if (isChecked){
                        backBtn.isChecked = false
                        textBtn.isChecked = false
                        root.colorIndex = 1
                    }
                }
            }
            CheckBtn{
                id: textBtn
                anchors.bottom: parent.bottom
                width: 100
                height: 50
                labelText: "文字"
                onIsCheckedChanged: {
                    if (isChecked){
                        backBtn.isChecked = false
                        keyBtn.isChecked = false
                        root.colorIndex = 2
                    }
                }
            }
        }

        Row{
            spacing: 10

            SliderProgress{
                id: redSlider
                width: 400
                height: 20
                sliderColor: "red"
                maxVlaue: 255
                onValueChanged: {
                    redEdit.content = value
                    if (root.colorIndex === 0) root.backgroundColor.r = value / 255
                    else if (root.colorIndex === 1) root.keyColor.r = value / 255
                    else if (root.colorIndex === 2) root.textColor.r = value / 255
                    root.setShowKeyObjectStyle()
                }
            }

            Text {
                font.pixelSize: 15
                color: "red"
                text: qsTr("R")
            }

            LineEdit{
                id: redEdit
                width: 50
                height: 20
                content: "0"
                onContentChanged: {
                    redSlider.value = content
                }
            }
        }

        Row{
            spacing: 10

            SliderProgress{
                id: greenSlider
                width: 400
                height: 20
                sliderColor: "green"
                maxVlaue: 255
                onValueChanged: {
                    greenEdit.content = value
                    if (root.colorIndex === 0) root.backgroundColor.g = value / 255
                    else if (root.colorIndex === 1) root.keyColor.g = value / 255
                    else if (root.colorIndex === 2) root.textColor.g = value / 255
                    root.setShowKeyObjectStyle()
                }
            }

            Text {
                font.pixelSize: 15
                color: "green"
                text: qsTr("G")
            }

            LineEdit{
                id: greenEdit
                width: 50
                height: 20
                content: "0"
                onContentChanged: {
                    greenSlider.value = content
                }
            }
        }

        Row{
            spacing: 10

            SliderProgress{
                id: blueSlider
                width: 400
                height: 20
                sliderColor: "blue"
                maxVlaue: 255
                onValueChanged: {
                    blueEdit.content = value
                    if (root.colorIndex === 0) root.backgroundColor.b = value / 255
                    else if (root.colorIndex === 1) root.keyColor.b = value / 255
                    else if (root.colorIndex === 2) root.textColor.b = value / 255
                    root.setShowKeyObjectStyle()
                }
            }

            Text {
                font.pixelSize: 15
                color: "blue"
                text: qsTr("B")
            }

            LineEdit{
                id: blueEdit
                width: 50
                height: 20
                content: "0"
                onContentChanged: {
                    blueSlider.value = content
                }
            }
        }

        Row{
            spacing: 10

            SliderProgress{
                id: alphaSlider
                width: 400
                height: 20
                sliderColor: "yellow"
                maxVlaue: 255
                onValueChanged: {
                    alphaEdit.content = value
                    if (root.colorIndex === 0) root.backgroundColor.a = value / 255
                    else if (root.colorIndex === 1) root.keyColor.a = value / 255
                    else if (root.colorIndex === 2) root.textColor.a = value / 255
                    root.setShowKeyObjectStyle()
                }
            }

            Text {
                font.pixelSize: 15
                color: "yellow"
                text: qsTr("A")
            }

            LineEdit{
                id: alphaEdit
                width: 50
                height: 20
                content: "0"
                onContentChanged: {
                    alphaSlider.value = content
                }
            }
        }
    }
}
