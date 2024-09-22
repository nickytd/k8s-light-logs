function add_time_and_systemd_attr(tag, timestamp, record)

  new_record = {}

  timeStr = os.date("!*t", timestamp["sec"])
  t = string.format("%4d-%02d-%02dT%02d:%02d:%02d.%sZ", timeStr["year"], timeStr["month"], timeStr["day"], timeStr["hour"], timeStr["min"], timeStr["sec"], timestamp["nsec"])

  new_record["time"] = t
  new_record["log"] = record["MESSAGE"]
  new_record["process.command"] = record["_EXE"]
  new_record["process.command_line"] = record["_CMDLINE"]
  new_record["process.pid"] = record["_PID"]
  new_record["host.name"] = record["_HOSTNAME"]
  new_record["host.id"] = record["_MACHINE_ID"]
  new_record["service.name"] = record["_SYSTEMD_UNIT"]
  new_record["service.namespace"] = record["_SYSTEMD_SLICE"]

  return 1, timestamp, new_record
end