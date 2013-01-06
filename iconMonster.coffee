loadPage = (url) ->
  casper.open(url).then ->
    pageIcons = @evaluate ->
      links = []
      $('a.thumbnail_link').each -> links.push $(@).attr('href')
      links
    # console.log pageIcons
    allIcons.push icon for icon in pageIcons
    hasNextPage = @evaluate -> $('.navigation a.next').length
    # console.log hasNextPage
    if hasNextPage
      nextPageURL = @evaluate -> $('.navigation a.next').attr('href')
      console.log nextPageURL
      loadPage nextPageURL
    else
      console.log allIcons
      downloadIcons()

downloadIcon = (url) ->
  console.log url
  casper.then ->
    casper.open(url).then ->
      pngURL = @evaluate -> $('a.download_png').attr('href')
      svgURL = @evaluate -> $('a.download_svg').attr('href')
      fileName = url.substr 22, url.length - 28
      console.log fileName
      console.log pngURL
      console.log svgURL
      casper.download(pngURL, fileName + '.png')
      casper.download(svgURL, fileName + '.svg')

downloadIcons = ->
  for icon in allIcons
    downloadIcon icon

casper = require('casper').create
  verbose: true
  logLevel: "debug"
  clientScripts: ["jquery.js"]

allIcons = []

casper.start().then ->
  loadPage 'http://iconmonstr.com/'

casper.run ->
  @echo 'Completed'
  @exit()
