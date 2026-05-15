const sha256Sync = require('sha256Sync');
const getType = require('getType');
const getEventData = require('getEventData');

// ==========================================
// 0. PRIVACY & CONSENT GATE (Google CoMo + Custom)
// ==========================================
if (data.enableConsentGate) {
  let hasMarketingConsent = false;
  let hasAnalyticsConsent = false;

  // Method A: Check Google Consent Mode v2 (Native Event Data)
  const consentState = getEventData('consent_state');
  if (consentState) {
    if (consentState.ad_storage === 'granted') hasMarketingConsent = true;
    if (consentState.analytics_storage === 'granted') hasAnalyticsConsent = true;
  }

  // Method B: Check Google Consent Mode v1 (x-ga-gcs header)
  // Format: G1[analytics][marketing] -> e.g., G110 (Analytics only), G111 (Both)
  if (!consentState) {
    const xGaGcs = getEventData('x-ga-gcs');
    if (xGaGcs && getType(xGaGcs) === 'string' && xGaGcs.length >= 3) {
      if (xGaGcs[2] === '1') hasMarketingConsent = true;
      if (xGaGcs[1] === '1') hasAnalyticsConsent = true;
    }
  }

  // Evaluate based on the user's selected requirement
  let consentMet = false;
  const requiredType = data.consentType || 'marketing'; 

  if (requiredType === 'marketing' && hasMarketingConsent) {
    consentMet = true;
  } else if (requiredType === 'analytics' && hasAnalyticsConsent) {
    consentMet = true;
  } else if (requiredType === 'both' && hasMarketingConsent && hasAnalyticsConsent) {
    consentMet = true;
  }

  // Method C: Fallback to Custom User-Defined Variable
  if (!consentMet && data.consentVariable) {
    let currentConsent = data.consentVariable;
    let expectedConsent = data.expectedConsentValue || 'granted';

    if (getType(currentConsent) === 'string') currentConsent = currentConsent.toLowerCase().trim();
    if (getType(expectedConsent) === 'string') expectedConsent = expectedConsent.toLowerCase().trim();

    if (currentConsent === expectedConsent || currentConsent === true) {
      consentMet = true;
    }
  }

  // If requirements are not met, safely kill the process
  if (!consentMet) {
    return undefined; 
  }
}

// ==========================================
// 1. DATA INGESTION (Manual vs Event Data)
// ==========================================
let rawInput;

if (data.inputMethod === 'event_data') {
  const userData = getEventData('user_data') || {};
  const field = data.userDataField;

  if (field === 'email_address') rawInput = userData.email_address;
  else if (field === 'phone_number') rawInput = userData.phone_number;
  else if (userData.address) {
    if (field === 'first_name') rawInput = userData.address.first_name;
    else if (field === 'last_name') rawInput = userData.address.last_name;
    else if (field === 'city') rawInput = userData.address.city;
    else if (field === 'region') rawInput = userData.address.region;
    else if (field === 'postal_code') rawInput = userData.address.postal_code;
    else if (field === 'country') rawInput = userData.address.country;
  }
} else {
  rawInput = data.input;
}

// ==========================================
// 2. TYPE SAFETY & BASE NORMALIZATION
// ==========================================
if (getType(rawInput) === 'undefined' || rawInput === null || rawInput === '') {
  return undefined; 
}

// Convert numbers (e.g., 12345678) to strings
if (getType(rawInput) === 'number') {
  rawInput = rawInput + '';
} else if (getType(rawInput) !== 'string') {
  return undefined; 
}

rawInput = rawInput.trim();

// Prevent double-hashing
function isAlreadyHashed(str) {
  return str && str.length === 64 && (str.match('^[A-Fa-f0-9]{64}$') !== null);
}

if (isAlreadyHashed(rawInput)) {
  return rawInput.toLowerCase(); 
}

// Set our working variable
let toHash = rawInput;

// ==========================================
// 3. UTILITY FUNCTIONS
// ==========================================
const replaceAll = function(str, oldstr, newstr) {
  if (!str || !oldstr) return str; 
  
  let rs = str + ''; 
  let searchStr = oldstr + '';
  let replaceStr = newstr + '';
  
  if (searchStr === replaceStr) return rs;
  while (rs.indexOf(searchStr) >= 0) {
    rs = rs.replace(searchStr, replaceStr);
  }
  return rs;
};

// ==========================================
// 4. TEXT & EMAIL NORMALIZATION
// ==========================================
if (data.toLowerCase) {
  toHash = toHash.toLowerCase();
}

if (data.removeGmailDots) {
  let emailParts = toHash.split('@');
  if (emailParts.length === 2) {
    let localPart = emailParts[0];
    let domainPart = emailParts[1];
    
    if (domainPart === 'gmail.com' || domainPart === 'googlemail.com') {
      localPart = replaceAll(localPart, '.', '');
      toHash = localPart + '@' + domainPart;
    }
  }
}

if (data.replaceCharacters && data.replacementTable) {
  for (let i = 0; i < data.replacementTable.length; i++) {
    let row = data.replacementTable[i];
    if (row.targetChar) {
      let replacement = row.replacementChar || ''; 
      toHash = replaceAll(toHash, row.targetChar, replacement);
    }
  }
}

if (data.removeCharacters && data.removalTable) {
  for (let i = 0; i < data.removalTable.length; i++) {
    let row = data.removalTable[i];
    if (row.charToRemove) {
      toHash = replaceAll(toHash, row.charToRemove, '');
    }
  }
}

if (data.removeWhiteSpaces) {
  toHash = replaceAll(toHash, ' ', '');
  toHash = replaceAll(toHash, '\t', ''); 
}

// --- Auto-Transliterate Standard European Characters ---
if (data.useStandardTransliteration) {
  const euroMap = [
    { t: 'æ', r: 'ae' }, { t: 'ø', r: 'oe' }, { t: 'å', r: 'aa' },
    { t: 'ä', r: 'ae' }, { t: 'ö', r: 'oe' }, { t: 'ü', r: 'ue' },
    { t: 'ß', r: 'ss' }, { t: 'œ', r: 'oe' }, { t: 'é', r: 'e' },
    { t: 'è', r: 'e' },  { t: 'ê', r: 'e' },  { t: 'ë', r: 'e' },
    { t: 'á', r: 'a' },  { t: 'à', r: 'a' },  { t: 'â', r: 'a' },
    { t: 'í', r: 'i' },  { t: 'ì', r: 'i' },  { t: 'î', r: 'i' },
    { t: 'ó', r: 'o' },  { t: 'ò', r: 'o' },  { t: 'ô', r: 'o' },
    { t: 'ú', r: 'u' },  { t: 'ù', r: 'u' },  { t: 'û', r: 'u' },
    { t: 'ñ', r: 'n' },  { t: 'ç', r: 'c' }
  ];

  for (let i = 0; i < euroMap.length; i++) {
    toHash = replaceAll(toHash, euroMap[i].t, euroMap[i].r);
  }
}

// ==========================================
// 5. ADVANCED PHONE NUMBER FORMATTING
// ==========================================
if (data.isPhoneNumber) {
  if (toHash.indexOf('00') === 0) {
    toHash = '+' + toHash.slice(2);
  }
  
  toHash = replaceAll(toHash, ' ', '');
  toHash = replaceAll(toHash, '-', '');
  toHash = replaceAll(toHash, '(', '');
  toHash = replaceAll(toHash, ')', '');
  toHash = replaceAll(toHash, '.', '');

  if (data.prefixStrategy === 'addPrefix') {
    
    // --- Sanitize function type safety ---
    const sanitizeConfigPrefix = function(pfx) {
      if (!pfx) return '';
      // Force user input to a string before cleaning
      let cleanPfx = replaceAll(pfx + '', ' ', ''); 
      if (cleanPfx.indexOf('00') === 0) cleanPfx = '+' + cleanPfx.slice(2);
      if (cleanPfx.indexOf('+') !== 0) cleanPfx = '+' + cleanPfx;
      return cleanPfx;
    };

    let prefix = sanitizeConfigPrefix(data.defaultCountryCode); 
    
    if (data.useDynamicCountryCode && data.countryCodeMapping) {
      let eventLocationKey = data.eventLocationKey || 'event_location.country';
      let eventCountryCode = getEventData(eventLocationKey);

      if (eventCountryCode && getType(eventCountryCode) === 'string') {
        eventCountryCode = eventCountryCode.toUpperCase();
        for (let i = 0; i < data.countryCodeMapping.length; i++) {
          let row = data.countryCodeMapping[i];
          if (row.isoCode && row.isoCode.toUpperCase() === eventCountryCode) {
            prefix = sanitizeConfigPrefix(row.dialingCode);
            break; 
          }
        }
      }
    }
    
    if (prefix) {
      let prefixDigits = replaceAll(prefix, '+', '');

      if (toHash.indexOf(prefix) === 0) {
        // Case 1
      } else if (toHash.indexOf(prefixDigits) === 0) {
        toHash = '+' + toHash;
      } else if (toHash.indexOf('+') === 0) {
        // Case 3
      } else {
        if (toHash.indexOf('0') === 0) {
          toHash = toHash.slice(1); 
        } else if (toHash.indexOf('8') === 0 && prefix === '+370') {
          toHash = toHash.slice(1); 
        }
        toHash = prefix + toHash;
      }
    }
  }
} else {
  if (data.removeLeadingZero) {
    if (toHash.indexOf('00') === 0) {
      toHash = toHash.slice(2);
    } else if (toHash.indexOf('0') === 0) {
      toHash = toHash.slice(1);
    }
  }
}

// ==========================================
// 6. FINAL PLATFORM NORMALIZATIONS & VALIDATION
// ==========================================
if (data.removePlus) {
  toHash = replaceAll(toHash, '+', '');
}

// --- EMAIL SANITY & OBFUSCATION CHECK ---
if (data.isEmail) {
  // 1. Check for standard front-end obfuscation (asterisks)
  if (toHash.indexOf('*') !== -1) {
    return undefined;
  }
  
  // 2. Sandbox-safe structural check
  let emailParts = toHash.split('@');
  
  // Must have exactly one '@', and text on both sides
  if (emailParts.length !== 2 || emailParts[0] === '' || emailParts[1] === '') {
    return undefined;
  }
  
  // The domain part must contain at least one dot
  if (emailParts[1].indexOf('.') === -1) {
    return undefined;
  }
}

// --- REGEX SANITY CHECK ---
if (data.isPhoneNumber) {
  // Regex pattern: 
  // ^\+? : Optionally starts with a '+'
  // [0-9]{5,15}$ : Followed by 5 to 15 digits until the end of the string.
  let isValidPhone = toHash.match('^\\+?[0-9]{5,15}$');
  
  if (!isValidPhone) {
    // It's better to return undefined than to send a useless garbage hash.
    return undefined; 
  }
}

// ==========================================
// 7. HASHING
// ==========================================
if (data.hashOutput) {
  return sha256Sync(toHash, {outputEncoding: 'hex'});
}

return toHash;