module Utils
    def ElementByCss(selector, timeout = 30)
    elements = ElementsByCss(selector, timeout)
    return elements.length > 0 ? elements[0] : browser.element(:css => selector)
  end
  
  def ElementsByCss(selector, timeout = 30)
    message = "waiting for #{selector} to become present"
    Watir::Wait.until(timeout: timeout, message: message) { browser.execute_script("return $('%s').length" % selector) > 0 }
    return browser.execute_script("return $('%s')" % selector)
  end
  
  def ElementByChildCss(element, selector, timeout = 30)
    elements = ElementsByChildCss(element, selector, timeout)
    return elements.length > 0 ? elements[0] : browser.element(:css => selector)
  end
  
  def ElementsByChildCss(element, selector, timeout = 30)
    message = "waiting for #{selector} to become present"
    Watir::Wait.until(timeout: timeout, message: message) { browser.execute_script(("return $(arguments[0]).find('%s').length" % selector), element) > 0 }
    return browser.execute_script(("return $(arguments[0]).find('%s')" % selector), element)
  end
end