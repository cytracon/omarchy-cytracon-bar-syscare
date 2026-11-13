import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as OmarchyCommons
import qs.Ui
import "Model.js" as Model

Panel {
  id: root
  moduleName: "io.github.cytracon.syscare"
  ipcTarget: "io.github.cytracon.syscare"
  manageIpc: (root.QsWindow.window !== null && root.QsWindow.window.screen === Quickshell.screens[0])

  property var anchorItem: null
  property var hostWidget: null

  readonly property string sourceUrl: "https://github.com/cytracon/omarchy-cytracon-syscare"
  readonly property string syscareBin: Quickshell.env("HOME") + "/.local/bin/syscare"
  readonly property color foreground: bar ? bar.foreground : OmarchyCommons.Color.foreground
  readonly property color dim: Qt.darker(foreground, 1.55)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  property bool installed: false
  property string liveVersion: ""
  property string hostname: ""
  property string osPretty: ""
  property string uptime: ""
  property string cpuLabel: "—"
  property string memLabel: "—"
  property string diskLabel: "—"
  property int updateCount: 0
  property string cleanResult: ""
  property int actionIndex: 0
  property bool cursorActive: false

  function open() {
    cursorActive = false
    actionIndex = 0
    cleanResult = ""
    refresh()
    root.controller.show()
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() {
    root.controller.hide()
  }

  function toggle() {
    if (root.opened) root.close()
    else root.open()
  }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
  }

  function refresh() {
    statusProc.running = false
    statusProc.running = true
    updatesProc.running = false
    updatesProc.running = true
  }

  function applyStatus(raw) {
    var status = Model.parseStatus(raw)
    root.installed = status.installed
    root.liveVersion = status.version
    root.hostname = status.hostname
    root.osPretty = status.os
    root.uptime = status.uptime
    root.cpuLabel = Model.percentLabel(status.cpuPercent)
    root.memLabel = Model.percentLabel(status.memPercent)
    root.diskLabel = Model.percentLabel(status.diskPercent)
  }

  function launchSysCare() {
    if (!root.installed) {
      installApp()
      return
    }
    Quickshell.execDetached([root.syscareBin])
    root.close()
  }

  function installApp() {
    Quickshell.execDetached([
      "omarchy-launch-floating-terminal-with-presentation",
      "omarchy", "install", "syscare"
    ])
    root.close()
  }

  function runSafeClean() {
    if (!root.installed) return
    cleanResult = "Cleaning safe user caches…"
    cleanProc.running = false
    cleanProc.running = true
  }

  function openSource() {
    Quickshell.execDetached(["omarchy-launch-browser", root.sourceUrl])
    root.close()
  }

  function activateCursor() {
    if (actionIndex === 0) launchSysCare()
    else if (actionIndex === 1) runSafeClean()
    else openSource()
  }

  Process {
    id: statusProc
    command: [root.syscareBin, "--status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applyStatus(text)
    }
    onExited: function(code) {
      if (code !== 0) {
        root.installed = false
        root.liveVersion = ""
      }
    }
  }

  Process {
    id: updatesProc
    command: [root.syscareBin, "--check-updates"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateCount = Model.parseUpdateCount(text)
    }
    onExited: function(code) {
      if (code !== 0) root.updateCount = 0
    }
  }

  Process {
    id: cleanProc
    command: [root.syscareBin, "--clean-safe"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.cleanResult = String(text || "").trim()
    }
    onExited: function(code) {
      if (code !== 0 && root.cleanResult === "Cleaning safe user caches…")
        root.cleanResult = "Safe clean failed"
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(420))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onMoveRequested: function(dx, dy) {
        root.cursorActive = true
        if (dy > 0) root.actionIndex = Math.min(2, root.actionIndex + 1)
        else if (dy < 0) root.actionIndex = Math.max(0, root.actionIndex - 1)
      }
      onActivateRequested: root.activateCursor()
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      onTextKey: function(t) {
        if (t === "o" || t === "O") root.launchSysCare()
        else if (t === "i" || t === "I") root.installApp()
        else if (t === "c" || t === "C") root.runSafeClean()
        else if (t === "s" || t === "S") root.openSource()
      }

      Column {
        id: column
        width: parent.width
        spacing: Style.space(12)

        PanelHero {
          width: parent.width
          title: "SysCare"
          meta: root.installed ? (root.liveVersion ? ("v" + root.liveVersion) : "installed") : "Not installed in ~/.local"
          foreground: root.foreground
          fontFamily: root.fontFamily
        }

        Column {
          width: parent.width
          spacing: Style.spacing.labelGap
          InfoPair { label: "Host"; value: root.hostname || "—" }
          InfoPair { label: "OS"; value: root.osPretty || "—" }
          InfoPair { label: "Uptime"; value: root.uptime || "—" }
          InfoPair { label: "CPU"; value: root.cpuLabel }
          InfoPair { label: "Memory"; value: root.memLabel }
          InfoPair { label: "Disk"; value: root.diskLabel }
          InfoPair { label: "Updates"; value: root.installed ? String(root.updateCount) : "—" }
        }

        PanelSeparator { foreground: root.foreground }

        ActionRow {
          width: parent.width
          title: root.installed ? "Open SysCare" : "Install SysCare"
          hint: root.installed ? "Right-click the bar icon, or press O" : "Installs the GTK app. Press I"
          selected: root.cursorActive && root.actionIndex === 0
          enabled: true
          onClicked: root.launchSysCare()
        }

        ActionRow {
          width: parent.width
          title: "Safe clean"
          hint: root.cleanResult !== "" ? root.cleanResult : "User caches only. No root. Press C"
          selected: root.cursorActive && root.actionIndex === 1
          enabled: root.installed
          onClicked: root.runSafeClean()
        }

        ActionRow {
          width: parent.width
          title: "Source"
          hint: "github.com/cytracon/omarchy-cytracon-syscare"
          selected: root.cursorActive && root.actionIndex === 2
          enabled: true
          onClicked: root.openSource()
        }
      }
    }
  }

  component InfoPair: Row {
    property string label: ""
    property string value: ""
    width: parent.width
    spacing: Style.space(8)
    Text {
      textFormat: Text.PlainText
      text: label
      color: root.foreground
      opacity: 0.6
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
    }
    Item {
      width: Math.max(0, parent.width - parent.children[0].implicitWidth - parent.children[2].implicitWidth - parent.spacing * 2)
      height: 1
    }
    Text {
      textFormat: Text.PlainText
      text: value
      color: root.foreground
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
      elide: Text.ElideRight
    }
  }

  component ActionRow: CursorSurface {
    id: action
    property string title: ""
    property string hint: ""
    property bool selected: false
    property bool enabled: true
    signal clicked()

    hasCursor: selected
    foreground: root.foreground
    implicitHeight: actionColumn.implicitHeight + Style.spacing.rowPaddingX
    opacity: enabled ? 1 : 0.55

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      enabled: action.enabled
      cursorShape: action.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
      onClicked: action.clicked()
    }

    Column {
      id: actionColumn
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: Style.space(10)
      anchors.rightMargin: Style.space(10)
      spacing: Style.space(2)
      Text {
        textFormat: Text.PlainText
        width: parent.width
        text: action.title
        color: root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.body
      }
      Text {
        textFormat: Text.PlainText
        width: parent.width
        text: action.hint
        color: root.dim
        font.family: root.fontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
      }
    }
  }
}
