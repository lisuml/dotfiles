// Michal - keep cookies and sessions after shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", false);
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);

// Michal - Disable the OCSP hard-fail
user_pref("security.OCSP.require", false);
