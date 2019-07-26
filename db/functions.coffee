# by-date
(doc) ->
  dtz = doc.time.split ' '
  [d, t, z] = [dtz[0], dtz[1], dtz[2]]
  # [year, month, day] = [d.getFullYear(), d.getMonth() + 1, d.getDate() + 1]
  emit dtz, doc.value

(keys, values) ->
