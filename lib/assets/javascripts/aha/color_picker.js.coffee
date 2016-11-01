# Aha's colorPicker plugin that Listens to the "changeColor" event 
class ColorPicker
  template: '<div class="small-colorpicker">' +
              '<div class="small-colorpicker-colors"></div>' + 
            '</div>'
  colors: [ 'ee9999', 'fdd4a3', 'ffee99', 'dfefc5', 'c1e39d', 'bddcdd', '99c7ec', 'c5dfe9', 'c2b7c8', 'ddbec7', 'f7c6c3', 'f1e2cf', 'cccccc', 
            'e24d4d', 'fbb35f', 'ffe24d', 'c8e29a', '93cd54', '8cc1c3', '4d9ddd', '9ac8d9', '95829e', 'c38d9e', 'f09c95', 'e7cdab', 'a5a5a5', 
            'd50000', 'f9931a', 'ffd500', 'b0d66e', '64b80a', '5ba7a9', '0173cf', '6fb0c8', '674c75', 'a95c74', 'ea7168', 'dcb787', '7f7f7f', 
            'aa0000', 'c77615', 'ccaa00', '8dab58', '509308', '498687', '015ca6', '598da0', '523d5e', '874a5d', 'bb5a53', 'b0926c', '666666', 
            '800000', '955810', '998000', '6a8042', '3c6e06', '376465', '01457c', '436a78', '3e2e46', '653746', '8c443e', '846e51', '4c4c4c']

  constructor: (element, @options) ->
    @options = {} unless @options
    @element = $(element)        
    return if @element.is('.disabled')
    @element.on 'click', (event) =>
      if @options.colorAttribute?
        @colors = $(element).attr(@options.colorAttribute).split(",")

      customColors = (@options.customColors || $(element).data('custom-colors') || [])
      @customColors = if typeof customColors == 'string'
        customColors.split(',')
      else
        customColors || []

      @picker ||= @createColorPicker()
      @placePicker()

      @picker.off "click.colorPickerColor"
      @picker.on "click.colorPickerColor", ".small-colorpicker-color", (event) =>
        hex = $(event.target).data('color')
        @input.minicolors('value', hex)
        @setHexColor(hex)
        @closePicker()
        false

      $(window).on 'click', @clickClosePicker

  clickClosePicker: (event) =>
    return if $(event.target)[0] == @element[0]
    return if $(event.target).is('.small-colorpicker-custom')
    return if $(event.target).is('.minicolors')
    return if $(event.target).parents('.minicolors').length > 0
    return unless @picker.is(':visible')
    @closePicker()

  closePicker: (event) =>
    enableScrolling() if window.enableScrolling
    $(window).off 'click', @clickClosePicker

    if @hexColor && @color
      @element.trigger(
        type: 'changeColor'
        color: {hex: @hexColor, converted: @color}
      )

    @picker.hide() if @picker

  createColorPicker: () ->
    picker = $(@template).appendTo("body")
    picker.data('colorPicker', @)
    colorsContainer = picker.find('.small-colorpicker-colors')

    initialColor = @element.data('color') || '#FFFFFF'
    initialColor = "##{initialColor}" unless initialColor[0] == '#'

    createColorDiv = (color) ->
      el = $("<div class='small-colorpicker-color' data-color='#{color}' style='background-color:##{color};'></div>")
      el.addClass('small-colorpicker-color-white') if color.toLowerCase() == 'ffffff'
      el

    createCustom = () ->
      container = $("<div/>").addClass("small-colorpicker-custom-container")
      label = $("<div/>").text("Custom:").addClass("small-colorpicker-custom-label")
      input = $("<input/>")
        .val(initialColor)
        .addClass("small-colorpicker-custom")
      container.append(label)
      container.append(input)

    if @options.displayRight
      picker.addClass('display-right')

    for color in @colors
      colorsContainer.append(createColorDiv(color))

    for color in @customColors
      colorsContainer.append(createColorDiv(color))

    colorsContainer.append(createCustom())

    @input = picker.find('.small-colorpicker-custom')
    @input.minicolors
      theme: 'colorpicker'
      change: (hex) =>
        @setHexColor(hex)
    @input.css
      backgroundColor: initialColor
      color: @fontFromColor(initialColor)
    @input.on 'keydown', (event) =>
      @closePicker() if event.which == 13
    picker.find('.minicolors-panel > div').each (_, div) ->
      $(div).css
        top: parseInt($(div).css('top')) + 3
        left: parseInt($(div).css('left')) + 3
    colorsContainer.append("<div class='clearfix'></div>").end()
   
  setHexColor: (hex) ->
    return unless /(^#[0-9A-F]{6}$)|(^#[0-9A-F]{3}$)/i.test(hex)
    unless @options.dontSetElementColor
      @element.css(backgroundColor: hex)
    @input.css
      backgroundColor: hex
      color: @fontFromColor(hex)
    hex = hex.replace('#', '')
    rgb = @hexToRGB(hex)
    @hexColor = hex
    @color = ((1 << 24) | (parseInt(rgb.r) << 16) | (parseInt(rgb.g) << 8) | parseInt(rgb.b))

  placePicker: () ->
    @picker.show()
    preventScrolling() if window.preventScrolling
    elemRect = @element[0].getBoundingClientRect()
    css = {}
    if elemRect.bottom - elemRect.height/2 < window.innerHeight/2
      css.top = @element.offset().top + @element.outerHeight()
      @picker.addClass('small-colorpicker-top-arrow').removeClass('small-colorpicker-bottom-arrow')
    else
      css.top = @element.offset().top - @picker.outerHeight()
      @picker.addClass('small-colorpicker-bottom-arrow').removeClass('small-colorpicker-top-arrow')

    if elemRect.right - elemRect.width/2 < window.innerWidth/2
      css.left = @element.offset().left - 8
      @picker.addClass('small-colorpicker-left-arrow').removeClass('small-colorpicker-right-arrow')
    else
      css.left = @element.offset().left + @element.width() - @picker.outerWidth() + 8
      @picker.addClass('small-colorpicker-right-arrow').removeClass('small-colorpicker-left-arrow')

    @picker.css(css)

  fontFromColor: (hex) ->
    rgb = @hexToRGB(hex.replace('#', ''))
    a = 1 - ( 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b)/255
    if a < 0.5
      '#000000'
    else
      '#FFFFFF'

  hexToRGB: (colorHex) ->
    bigint = parseInt(colorHex, 16);
    {r: (bigint >> 16) & 255, g: (bigint >> 8) & 255, b: bigint & 255}

#
# Create JQuery plugin from class
#
extendOptions = {}
extendOptions["colorPicker"] = (option, args...) ->
  @each ->
    $this = $(this)
    
    unless data = $this.data("colorPicker")
      $this.data "colorPicker", (data = new ColorPicker($this, option))
    if typeof option == 'string'
      data[option].apply(data, args)
$.fn.extend extendOptions
