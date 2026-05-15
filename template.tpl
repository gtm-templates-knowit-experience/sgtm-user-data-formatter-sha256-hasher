___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_WV3WH",
  "version": 1,
  "displayName": "User Data Formatter \u0026 SHA256 Hasher",
  "categories": [
    "UTILITY"
  ],
  "description": "Normalizes, transliterates, and hashes User Data (Email, Phone, Name etc. ) with SHA256 for Meta, Google, TikTok, Snapchat etc.. Features smart E.164 phone logic and Gmail dot removal.",
  "containerContexts": [
    "SERVER"
  ],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "inputMethod",
    "displayName": "Data Source",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "manual",
        "displayValue": "Map a Custom Variable (Manual)"
      },
      {
        "value": "event_data",
        "displayValue": "Extract from Event Data (user_data object)"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "manual"
  },
  {
    "type": "TEXT",
    "name": "input",
    "displayName": "Value to hash",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": false,
    "enablingConditions": [
      {
        "paramName": "inputMethod",
        "paramValue": "manual",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "userDataField",
    "displayName": "Parameter to Extract",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "email_address",
        "displayValue": "Email Address"
      },
      {
        "value": "phone_number",
        "displayValue": "Phone Number"
      },
      {
        "value": "first_name",
        "displayValue": "First Name"
      },
      {
        "value": "last_name",
        "displayValue": "Last Name"
      },
      {
        "value": "city",
        "displayValue": "City"
      },
      {
        "value": "region",
        "displayValue": "Region/State"
      },
      {
        "value": "postal_code",
        "displayValue": "Postal/ZIP Code"
      },
      {
        "value": "country",
        "displayValue": "Country"
      }
    ],
    "simpleValueType": true,
    "help": "Select which parameter to automatically extract from the GA4 user_data object.",
    "enablingConditions": [
      {
        "paramName": "inputMethod",
        "paramValue": "event_data",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "genericGroup",
    "displayName": "Generic Settings",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "toLowerCase",
        "checkboxText": "Convert to Lower Case",
        "simpleValueType": true,
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "hashOutput",
        "checkboxText": "Hash output (SHA256)",
        "simpleValueType": true,
        "defaultValue": true
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "consentGroup",
    "displayName": "Consent Settings",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableConsentGate",
        "checkboxText": "Require Consent",
        "simpleValueType": true,
        "help": "Automatically detects Google Consent Mode (v1 \u0026 v2). If not using Consent Mode, you can optionally map a custom variable below."
      },
      {
        "type": "SELECT",
        "name": "consentType",
        "displayName": "Required Consent Type",
        "selectItems": [
          {
            "value": "marketing",
            "displayValue": "Ad Storage (Marketing)"
          },
          {
            "value": "analytics",
            "displayValue": "Analytics Storage"
          },
          {
            "value": "both",
            "displayValue": "Both Ad Storage \u0026 Analytics Storage"
          }
        ],
        "simpleValueType": true,
        "help": "Select which Google Consent Mode category is required to process this data.",
        "enablingConditions": [
          {
            "paramName": "enableConsentGate",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "customConsent",
        "checkboxText": "Custom Consent Values",
        "simpleValueType": true,
        "help": "If you are not using Google Consent Mode, use Custom Consent Values instead.",
        "enablingConditions": [
          {
            "paramName": "enableConsentGate",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "consentVariable",
        "displayName": "Custom Consent Variable (Optional Fallback)",
        "simpleValueType": true,
        "help": "If you are not using Google Consent Mode, map your custom CMP variable here (e.g., {{Consent - Cookiebot - Marketing}})",
        "enablingConditions": [
          {
            "paramName": "customConsent",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "expectedConsentValue",
        "displayName": "Expected \u0027Granted\u0027 Value",
        "simpleValueType": true,
        "valueHint": "granted",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "customConsent",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "The value your custom variable returns when consent is given. Usually \u0027granted\u0027, \u0027true\u0027, or \u00271\u0027."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "emailNameGroup",
    "displayName": "Email \u0026 Address Settings",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "subParams": [
      {
        "type": "GROUP",
        "name": "genericEmailNameGroup",
        "displayName": "Generic Settings",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "removeWhiteSpaces",
            "checkboxText": "Remove White Spaces",
            "simpleValueType": true
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "emailGroup",
        "displayName": "Email Settings",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "removeGmailDots",
            "checkboxText": "Remove periods from Gmail addresses before the @ symbol",
            "simpleValueType": true
          },
          {
            "type": "CHECKBOX",
            "name": "isEmail",
            "checkboxText": "Validate Email Format \u0026 Drop Obfuscation",
            "simpleValueType": true,
            "help": "Checks for front-end obfuscation (e.g., user***@gmail.com) and invalid email structures. If detected, the template safely returns undefined to prevent sending garbage hashes to ad networks."
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "replaceCharactersGroup",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "useStandardTransliteration",
            "checkboxText": "Apply standard EU/MRZ Transliteration",
            "simpleValueType": true,
            "help": "Automatically transliterates common European and accented characters to standard a-z format to maximize Match Quality. Use the custom table below for additional edge cases."
          },
          {
            "type": "CHECKBOX",
            "name": "replaceCharacters",
            "checkboxText": "Enable Character Replacement / Transliteration",
            "simpleValueType": true
          },
          {
            "type": "SIMPLE_TABLE",
            "name": "replacementTable",
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Character to find",
                "name": "targetChar",
                "type": "TEXT"
              },
              {
                "defaultValue": "",
                "displayName": "Replace with",
                "name": "replacementChar",
                "type": "TEXT"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "replaceCharacters",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "displayName": "Character Replacement"
          },
          {
            "type": "CHECKBOX",
            "name": "removeCharacters",
            "checkboxText": "Remove specific characters",
            "simpleValueType": true
          },
          {
            "type": "SIMPLE_TABLE",
            "name": "removalTable",
            "displayName": "Character Removal",
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Character to remove",
                "name": "charToRemove",
                "type": "TEXT"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "removeCharacters",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ],
        "displayName": "Address Settings",
        "help": "Address settings can be relevant for Name, Street, City, Region, Postal Code"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "phoneSettingsGroup",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "isPhoneNumber",
        "checkboxText": "Is this a Phone Number?",
        "simpleValueType": true
      },
      {
        "type": "SELECT",
        "name": "prefixStrategy",
        "displayName": "Do Nothing OR Apply Default Country Code",
        "selectItems": [
          {
            "value": "none",
            "displayValue": "Do Nothing"
          },
          {
            "value": "addPrefix",
            "displayValue": "Apply Default Country Code"
          }
        ],
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "isPhoneNumber",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "defaultCountryCode",
        "displayName": "Default Dialing Prefix",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "prefixStrategy",
            "paramValue": "addPrefix",
            "type": "EQUALS"
          }
        ],
        "valueHint": "E.g., +1 or +44",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "useDynamicCountryCode",
        "checkboxText": "Use dynamic prefix based on Event Data",
        "simpleValueType": true,
        "help": "If checked, the template will check the incoming event data for a country code (like \"NO\" or \"US\") and map it to a specific dialing prefix. If no match is found, it will fall back to your Default Country Code.",
        "enablingConditions": [
          {
            "paramName": "prefixStrategy",
            "paramValue": "addPrefix",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "eventLocationKey",
        "displayName": "Event Data Key path",
        "simpleValueType": true,
        "help": "The dot-notation path to the country data in your sGTM Event. event_location.country is standard for GA4 clients.",
        "enablingConditions": [
          {
            "paramName": "useDynamicCountryCode",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "defaultValue": "event_location.country"
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "countryCodeMapping",
        "displayName": "Country Code Mappings",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "ISO Country Code",
            "name": "isoCode",
            "type": "TEXT",
            "isUnique": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "valueHint": "E.g., NO, US, SE"
          },
          {
            "defaultValue": "",
            "displayName": "Dialing Prefix",
            "name": "dialingCode",
            "type": "TEXT",
            "valueHint": "E.g., +47, +1, +46"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "useDynamicCountryCode",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": []
      },
      {
        "type": "CHECKBOX",
        "name": "removePlus",
        "checkboxText": "Remove plus sign in front of Phone Number",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "isPhoneNumber",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ],
    "displayName": "Phone Settings"
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 8/15/2022, 5:25:17 PM


