class Constants
  CSRF_SIZE       = 64
  CSRF_COOKIE     = "csrf_cookie"
  CSRF_TOKENS     = "csrf_tokens"
  CSRF_HEADER     = "csrf_header"

  PATH_REGEX      = /http[s]?:\/\/([^\/]*)\/([^?]*)/
  ROOT_URL_REGEX  = /(http[s]?:\/\/[^\/]*)\/([^?]*)/

  US_NUM_REGEX    = /^((?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d{1,2})?)(\$?)$/
  CAD_NUM_REGEX   = /^((?:-?\d+|-?\d{1,3}(?:\s\d{3})+)?(?:,\d{1,2})?)(\$?)$/
  EMAIL_REGEX     = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/i

  US_FLOAT_REGEX    = /^((?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d+)?)(\$?)$/
  CAD_FLOAT_REGEX   = /^((?:-?\d+|-?\d{1,3}(?:\s\d{3})+)?(?:,\d+)?)(\$?)$/

  # For the images urls in the emails, localhost doesn't work in dev
  IMAGE_ROOT_URL  = "http://afl-prod.herokuapp.com"

  # The beginning of I18N
  DATE_FORMAT_LABEL        = "JJ-MM-AAAA"
  DATE_FORMAT_LABEL_LONG   = "JJ[-]MM[-]AAAA"
  DATE_FORMAT_FR_CA        = "%d-%m-%Y"
  DATE_FORMAT_FR_CA_SHORT  = "%d%m%Y"
  # Double escape the backslash
  DATE_RE               = "\\\\d{2}-\\\\d{2}-\\\\d{4}"
  DATE_RE_SHORT         = "\\\\d{8}"
  DATE_PICKER_DEFAULT   = "dd-mm-yy"
  DATE_METHOD           = "userDate"    # This one should not change

   # Double escape the backslash
  MONTH_YEAR_RE            = "\\\\d{2}-\\\\d{4}"
  MONTH_YEAR_FORMAT_LABEL  = "MM-AAAA"

  # The startup time, for the JS files
  TS = Time.now.to_i

end
