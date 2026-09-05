// Parse SysCare CLI JSON for the bar panel. Locale-free so it can be
// exercised outside QML.

function emptyStatus() {
  return {
    installed: false,
    version: "",
    hostname: "",
    os: "",
    uptime: "",
    cpuPercent: 0,
    memPercent: 0,
    diskPercent: 0,
    processCount: 0
  }
}

function parseStatus(raw) {
  var text = String(raw || "").trim()
  var status = emptyStatus()
  if (text === "") return status
  try {
    var data = JSON.parse(text)
  } catch (e) {
    return status
  }
  if (!data || typeof data !== "object") return status
  status.installed = true
  status.version = String(data.version || "")
  status.hostname = String(data.hostname || "")
  status.os = String(data.os || "")
  status.uptime = String(data.uptime || "")
  status.cpuPercent = Number(data.cpu_percent || 0)
  status.memPercent = Number(data.mem_percent || 0)
  status.diskPercent = Number(data.disk_percent || 0)
  status.processCount = Number(data.process_count || 0)
  return status
}

function parseUpdateCount(raw) {
  var text = String(raw || "").trim()
  if (text === "") return 0
  try {
    var data = JSON.parse(text)
  } catch (e) {
    return 0
  }
  if (Array.isArray(data)) return data.length
  if (data && Array.isArray(data.updates)) return data.updates.length
  return 0
}

function percentLabel(value) {
  var n = Number(value)
  if (isNaN(n)) return "—"
  return Math.round(n) + "%"
}
