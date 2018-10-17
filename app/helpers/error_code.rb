module ErrorCode

  # Security/Server param validation failure
  S001 = "Error S001: client-server field validation failed"
  S002 = "Error S002: Missing CSRF token in the POST"
  S003 = "Error S003: Missing CSRF token list in session"
  S004 = "Error S004: Invalid CSRF token"
  S005 = "Error S005: Invalid referer header"
  S006 = "Error S006: Recording unauthorized, QS contains a ?"
  S007 = "Warn  S007: The user is black listed by IP"   # Warning, unauth robots are doing this...
  S008 = "Error S008: Input contains the forbidden characters"
  S009 = "Error S009: The user is black listed by email"
  S010 = "Error S010: pid validation without a session"
  S011 = "Error S011: Error on max length"
  S012 = "Error S012: Error on min length"
  S013 = "Error S013: Error on email validation"
  S014 = "Error S014: Invalid CSRF Header"

  # Platform issues
  P001 = "Error P001: Failed to send an email"
  P002 = "Error P002: Content-Security-Policy"
  P003 = "Error P003: Mongoid error"
  P004 = "Warn  P004: Routing defect"
  P005 = "Error P005: JavaScript Error "
  P006 = "Error P006: 500"

  P009 = "Error P009: Failed to format date"
  P010 = "Error P010: Failure in auditing"
  P011 = "Info  P011: Deleting Dbox file"  
end
