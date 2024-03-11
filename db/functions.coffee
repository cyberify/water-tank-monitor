# by-day
(doc) ->
  dtz = doc.time.split ' '
  [d, t, z] = [dtz[0], dtz[1], dtz[2]]
  "#{d.getHours()}:#{d.getMinutes()}:#{d.getSeconds()}"
  emit dtz, doc.value

# todo: complete this
(keys, values) ->
  # arr1.map((x, i) => [x, arr2[i]]);
  # rows =