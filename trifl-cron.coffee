module.exports = (robot) ->
  cronJob = require('cron').CronJob
  # Deberia llamar a la función a las 11 AM los días de semana
  # Chequear que el TimeZone sea el correcto (https://leanpub.com/automation-and-monitoring-with-hubot/read#leanpub-auto-periodic-task-execution)
  new cronJob('0 00 11 * * 1-5', workdaysElevenAm(robot), null, true)
  console.log cronJob

workdaysElevenAm = (robot) ->
  ->
  food_flow_id = "INSERT_FLOW_ID"
  TRIFL_MENU_ENDPOINT = "http://gettrifl.com/api/beta/menu?hood=palermo"
  robot.http(TRIFL_MENU_ENDPOINT)
   .get() (err, res, body) ->
    json_body = null
    if res
     switch res.statusCode
      when 200 then json_body = JSON.parse(body)
      else
       robot.messageRoom food_flow_id,  "Unable to fetch Trifl menu! :("
       return
    
     if json_body and json_body.options and json_body.date
      console.log json_body
      robot.messageRoom food_flow_id,  "@team " + json_body.date 
      for option in json_body.options
       availability = `option.soldOut ? "AGOTADO":"DISPONIBLE"`
       robot.messageRoom food_flow_id,  "[" + availability + "]  \"" + option.name + "\"\n" + option.picture + "\n\t" + option.description
     else
      robot.messageRoom food_flow_id,  "Invalid response from Trifl :("
