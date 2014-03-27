express  = require 'express'
http     = require 'http'
path     = require 'path'
routes   = require './routes'
stylus   = require 'stylus'
mongoose = require 'mongoose'

dbUrl = 'mongodb://localhost/drudge'

app = express()

mongoose.connect dbUrl

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.methodOverride()
  app.use express.favicon './public/images/favicon.ico'
  app.use app.router
  app.use express.static path.join 'public'

app.configure 'development', ->
  app.use express.errorHandler()

app.post '/save', routes.save
app.get '/:id', routes.drudge
app.get '/', routes.index


http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port " + app.get('port')