import QtQuick

Item {
    property var showKeyObject: null
    property color backgroundColor: "#80808080"
    property color keyColor: "#80C0C0C0"
    property color textColor: "black"
    property int colorIndex: 0
    property int stayTime: 3000
    property int locationIndex: 6

    id: root

    function setShowKeyObjectStyle(){
        if (root.showKeyObject !== null)
            root.showKeyObject.setStyle(root.backgroundColor, root.keyColor, root.textColor, root.stayTime, root.locationIndex)
    }

    Column{
        spacing: 20

        Row{ // 开关 位置
            spacing: 10

            Rectangle{ // 按键预览及启动关闭
                property bool isOpen: false

                id: startRect
                width: 120
                height: 120
                visible: true
                radius: 30
                color: root.backgroundColor

                Rectangle{
                    width: 96
                    height: 96
                    radius: 30
                    anchors.centerIn: parent
                    color: root.keyColor
                    visible: true

                    Text {
                        text: startRect.isOpen ? "关闭" : "打开"
                        anchors.centerIn: parent
                        color: root.textColor
                        font.pixelSize: 24
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

            GridView{ // 位置
                id: locationGrid
                width: 120
                height: 120
                cellWidth: 40
                cellHeight: 40
                interactive: false // 禁止滑动
                currentIndex: root.locationIndex

                model: ListModel{
                    ListElement{content: "↖"}
                    ListElement{content: "↑"}
                    ListElement{content: "↗"}
                    ListElement{content: "←"}
                    ListElement{content: "·"}
                    ListElement{content: "→"}
                    ListElement{content: "↙"}
                    ListElement{content: "↓"}
                    ListElement{content: "↘"}
                }

                delegate: Rectangle{
                    width: 40
                    height: 40
                    radius: 15
                    color: "#80808080"

                    Text {
                        text: content
                        anchors.centerIn: parent
                        color: "black"
                        font.pixelSize: 15
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            locationGrid.currentIndex = index
                            root.locationIndex = index
                            root.setShowKeyObjectStyle()
                        }
                    }
                }

                highlight: Rectangle{
                    width: 40
                    height: 40
                    radius: 15
                    color: "#C0C0C0"
                }
            }
        }

        Row{ // 设置类型
            spacing: 10

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
                        redSlider.value = root.backgroundColor.r * 255
                        greenSlider.value = root.backgroundColor.g * 255
                        blueSlider.value = root.backgroundColor.b * 255
                        alphaSlider.value = root.backgroundColor.a * 255
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
                        redSlider.value = root.keyColor.r * 255
                        greenSlider.value = root.keyColor.g * 255
                        blueSlider.value = root.keyColor.b * 255
                        alphaSlider.value = root.keyColor.a * 255
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
                        redSlider.value = root.textColor.r * 255
                        greenSlider.value = root.textColor.g * 255
                        blueSlider.value = root.textColor.b * 255
                        alphaSlider.value = root.textColor.a * 255
                    }
                }
            }

            ClickBtn{
                id: resetBtn
                anchors.bottom: parent.bottom
                width: 100
                height: 50
                btnText: "重置"
                btnColor: "red"
                onClicked: {
                    root.backgroundColor = "#80808080"
                    root.keyColor = "#80C0C0C0"
                    root.textColor = "black"
                    timeSlider.value = 3000
                    locationGrid.currentIndex = 6
                    root.locationIndex = 6
                    if (root.colorIndex === 0){
                        redSlider.value = root.backgroundColor.r * 255
                        greenSlider.value = root.backgroundColor.g * 255
                        blueSlider.value = root.backgroundColor.b * 255
                        alphaSlider.value = root.backgroundColor.a * 255
                    }else if (root.colorIndex === 1){
                        redSlider.value = root.keyColor.r * 255
                        greenSlider.value = root.keyColor.g * 255
                        blueSlider.value = root.keyColor.b * 255
                        alphaSlider.value = root.keyColor.a * 255
                    }else if (root.colorIndex === 2){
                        redSlider.value = root.textColor.r * 255
                        greenSlider.value = root.textColor.g * 255
                        blueSlider.value = root.textColor.b * 255
                        alphaSlider.value = root.textColor.a * 255
                    }
                    root.setShowKeyObjectStyle()
                }
            }
        }

        Row{ // R
            spacing: 10

            SliderProgress{
                id: redSlider
                width: 400
                height: 20
                sliderColor: "red"
                maxVlaue: 255
                value: root.backgroundColor.r * 255
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
                    if (content === "") content = "0"
                    if (content > 255) content = 255
                    else if (content < 0) content = 0
                    redSlider.value = content
                }
            }
        }

        Row{ // G
            spacing: 10

            SliderProgress{
                id: greenSlider
                width: 400
                height: 20
                sliderColor: "green"
                maxVlaue: 255
                value: root.backgroundColor.g * 255
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
                    if (content === "") content = "0"
                    if (content > 255) content = 255
                    else if (content < 0) content = 0
                    greenSlider.value = content
                }
            }
        }

        Row{ // B
            spacing: 10

            SliderProgress{
                id: blueSlider
                width: 400
                height: 20
                sliderColor: "blue"
                maxVlaue: 255
                value: root.backgroundColor.b * 255
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
                    if (content === "") content = "0"
                    if (content > 255) content = 255
                    else if (content < 0) content = 0
                    blueSlider.value = content
                }
            }
        }

        Row{ // A
            spacing: 10

            SliderProgress{
                id: alphaSlider
                width: 400
                height: 20
                sliderColor: "yellow"
                maxVlaue: 255
                value: root.backgroundColor.a * 255
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
                    if (content === "") content = "0"
                    if (content > 255) content = 255
                    else if (content < 0) content = 0
                    alphaSlider.value = content
                }
            }
        }

        Row{ // T
            spacing: 10

            SliderProgress{
                id: timeSlider
                width: 400
                height: 20
                sliderColor: "#00ffff"
                maxVlaue: 5000
                value: root.stayTime
                onValueChanged: {
                    timeEdit.content = value
                    root.stayTime = value
                    root.setShowKeyObjectStyle()
                }
            }

            Text {
                font.pixelSize: 15
                color: "#00ffff"
                text: qsTr("T")
            }

            LineEdit{
                id: timeEdit
                width: 50
                height: 20
                content: timeSlider.value
                onContentChanged: {
                    if (content === "") content = "0"
                    if (content > 5000) content = 5000
                    else if (content < 0) content = 0
                    timeSlider.value = content
                }
            }
        }
    }
}
