# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  class Map
    constructor: (@elem, @zoom)->
      @offsetRow = 0
      @offsetCol = 0
      @elem.addClass 'zoom_' + @zoom
      @populate()


    draw: ->
      @elem.html ''
      for row in [0..@rows()]
        @createRow()
        if row == 0
          @row.addClass 'numbered'
          @row.append @numberedCell('', 'top left', -1)
          for col in [1..@cols()]
            @row.append @numberedCell(col, 'top', col % 2)
        else
          for col in [0..@cols()]
            if col == 0
              @row.append @numberedCell(row, 'left', row % 2)
            else
              @row.append @createCell(@offsetRow + row, @offsetCol + col)

    rows: ->
      height = ($(window).height() - $('#map')[0].offsetTop - 25)
      parseInt((height / (@size() + 2)).toFixed()) - 1

    cols: ->
      width = ($('#map').width() - 25)
      parseInt((width / (@size() + 2)).toFixed()) - 1

    size: ->
      return 100 if @zoom == 0
      (6 - @zoom) * 10

    startEdit: (cell)=>
      row = cell.data 'row'
      col = cell.data 'col'
      @editor = new CellEditor(row, col, @details(row, col))

    update: ->
      @editor.save(@obj)
      @editor = null
      @draw()


    createRow: ->
      @row = $("<div class='row'></div>")
      @elem.append @row

    createCell: (row, col)->
      cell = $("<div class='cell'></div>")
      cell.addClass @details(row, col).cell_type
      cell.data 'row', row
      cell.data 'col', col

    numberedCell: (num, classname, parity)->
      parity_classname = 'even' if parity == 0
      parity_classname = 'odd'  if parity == 1
      cell = $("<div class='number cell " + classname + " " + parity_classname + "'>" + num + "</div>")
      cell.addClass 'numbered'


    details: (row, col)->
      details = if @obj[row] && @obj[row][col]
        @obj[row][col]
      else
        {}


    populate: ->
      options =
        offset_row: @offsetRow
        offset_col: @offsetCol
        zoom: @zoom
        row_size: @rows()
        col_size: @cols()
      $.get 'list', options, (data)=>
        @obj = data
        @draw()

  class CellEditor
    constructor: (@row, @col, details)->
      details.owner ||= {}
      $('.editor').show()
      $('.editor #cell_type').val(details.cell_type)
      $('.editor #level').val(details.level)
      $('.editor #owner #name').html(details.owner.name)
      $('.editor #owner #tags').html(details.owner.tags)
      $('.editor #owner #comments').html(details.owner.comments)

    details: ->
      row: @row
      col: @col
      cell_type: $('.editor #cell_type').val()
      level: $('.editor #level').val()
      owner:
        name: $('.editor #owner #name').innerHTML
        tags: $('.editor #owner #tags').innerHTML
        comments: $('.editor #owner #comments').innerHTML

    save: (obj)->
      obj[@row] ||= {}
      obj[@row][@col] = @details()
      $.post '/home/set', {details: @details()}
      $('.editor').hide()


  window.map = new Map $('#map'), zoom_level

  $('#map').on 'click', '.cell', ->
    map.startEdit $(this)

  $('#update_home').click (event)->
    map.update()
    event.preventDefault()


  $(window).resize ->
    map.draw()
