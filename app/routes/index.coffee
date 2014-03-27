mongoose = require 'mongoose'
request  = require 'request'
cheerio  = require 'cheerio'

Schema   = mongoose.Schema
ObjectId = Schema.ObjectId

DrudgeSchema = new Schema
  short : String
  image : String
  title : String

Drudge = mongoose.model 'Drudge', DrudgeSchema


makeSlug = ->
  set  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  slug = ''
  slug += set[Math.floor Math.random() * set.length] for n in [0..3]
  slug


exports.index = (req, res) ->
  res.render 'index'


exports.save = (req, res) ->
  drudge = new Drudge req.body
  drudge.short = makeSlug()
  drudge.save()
  res.render 'index'


exports.drudge = (req, res) ->
  request 'http://www.drudgereport.com', (err, response, body) ->
    $ = cheerio.load body

    Drudge.findOne { 'short' : req.params.id }, (err, drudge) ->

      headlineHtml = $('#drudgeTopHeadlines').html()
      headlineHtml = headlineHtml.split '<center>\r\n<br><br><br>'
      headlineHtml[0] = headlineHtml[0] + '<center>\r\n<br><br><br><font face="ARIAL,VERDANA,HELVETICA"><font size="+7">'
      headlineHtml[1] = '<img src="' + drudge.image + '" width="450"><br><a href="#">' + drudge.title  + '</a>'
      headlineHtml[2] = '</font></font></center>\r\n<!-- Main headlines links END --->\r\n</b></tt>\r\n'
      headlineHtml = headlineHtml.join('')

      $('#drudgeTopHeadlines').html headlineHtml
      
      res.send $.html()