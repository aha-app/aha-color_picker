$ = require('jquery')

stopEvents = (e)->
  e.preventDefault()
  e.stopPropagation()

# Prevent user from being able to scroll (good for modals and popups).
preventScrolling = ()->
  $window = $(window)
  $window.bind('mousewheel DOMMouseScroll wheel', stopEvents);

  # Prevent user from clicking/scrolling on main window scrollbar.
  scrollX = $window.scrollLeft()
  scrollY = $window.scrollTop()
  window.onscroll = ()->
    window.scrollTo(scrollX, scrollY)

# Allow the user to scroll again.
enableScrolling = ()->
  $window = $(window)
  $window.unbind('mousewheel DOMMouseScroll wheel', stopEvents);

  # Allow user to resume clicking/scrolling on main window scrollbar.
  window.onscroll = null

module.exports =
  preventScrolling: preventScrolling
  enableScrolling: enableScrolling
