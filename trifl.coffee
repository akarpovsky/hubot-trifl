module.exports = (robot) ->
 robot.respond /(showmethefood|gettrifl|trifl)/i, (msg) ->
  TRIFL_MENU_ENDPOINT = "http://gettrifl.com/api/beta/menu?hood=palermo"
  msg.http(TRIFL_MENU_ENDPOINT)
   .get() (err, res, body) ->
    json_body = null
    switch res.statusCode
     when 200 then json_body = JSON.parse(body)
     else
      msg.send "Unable to fetch Trifl menu! :("
      return
    
    if json_body
     if !json_body.soldOut and !json_body.options and !json_body.name and !json_body.picture and !json_body.description
      msg.send "Invalid response from Trifl :("
      return
    msg.send "@team " + json_body.date 
    for option in json_body.options
     availability = `option.soldOut ? "AGOTADO":"DISPONIBLE"`
     msg.send "[" + availability + "]  \"" + option.name + "\"\n" + option.picture + "\n\t" + option.description
