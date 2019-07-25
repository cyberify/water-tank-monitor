(doc) ->
  d = new Date doc.time
  [year, month, day] = [d.getFullYear(), d.getMonth() + 1, d.getDate() + 1]
  emit [year, month, day], doc.value

(keys, values) ->
