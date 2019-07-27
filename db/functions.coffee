# by-day
(doc) ->
  dtz = doc.time.split ' '
  [d, t, z] = [dtz[0], dtz[1], dtz[2]]
  emit dtz, doc.value

(keys, values) ->
  # arr1.map((x, i) => [x, arr2[i]]);
  rows =