___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Tagglo Tag Monitor",
    "categories": [
    "ADVERTISING",
    "ANALYTICS",
    "MARKETING",
    "TAG_MANAGEMENT"
  ],
  "brand": {
    "id": "https://github.com/tagglo",
    "displayName": "Tagglo",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJYAAACWCAYAAAA8AXHiAAAACXBIWXMAAAsSAAALEgHS3X78AAADNklEQVR4nO3dvU5UQQCG4cGYaAKGDrAlAe9gtdFOS6iU0gpLwwV4A3bEUipLLEig1E4b3TsQE0t/6IiQSIWZWBAqYOFb9+w8Tz+TyebNnN2TOXsmjr5vHRe4Ytd8oCQIiwhhESEsIoRFhLCIEBYRwiJCWEQIiwhhESEsIq77WP/Z3O6XzZ1++bm3f+4xczPTZWWpV1aWe9nFdZDTDaWU9Y335e1Of+DxT5Z6ZW314ZWuqeuavxR+/fbrUlFVdXydhxPNh/Xh05eRmmdcNB/Wrp0movmwDg7/jMAqxk/zYZEhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiOjsk9D1Ob7fZzwIcWvyZlmYnx3amjjRqbB+7O2X9dfvysfPuxcad//uYll79qjcnpmOrY3TOnMprFE9fb5x4aiqOqaO/XGB/2XgcjoTVt2pDg6PBh5fx9Y5GI7OhDXITpWYg/Pxq5AIYREhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiPAunSFq6dSrsMJaPfXqUhjU8qlXYQW1fOpVWEEtn3oVVkjrr5kTVshZv/7GnbCIEBYRwiJCWEQIiwhhESEsIoRFhLCI6ExY9RjJKMzB+XQmrHo2aWryxsDj69g6B8PRmbDqgbc3r1YH2nXqmDrWX0UOT6dOkNYwXr54PAIr4Sy+vBMhLCKERYSwQupjXC0TVkjrb8QQVlDLN3WFFdTyTV1hBbV8U9cj9mGt3tS1YxEhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiBAWEcIiQlhECIsIYREhLCKERYSwiBAWEcIiQlhECIuI5sOaavxt8ynNh7XY+NvmU5oP68G9OyM1z7hoPqyF+dnyZKl3qTnq+AU73ykTR9+3jkdoPf/N5na/bO70y8+9/XMvYW5muqws9crK8uXCHEfCIqL5SyEZwiJCWEQIiwhhESEsIoRFhLCIEBYRwuLqlVL+Av6nrpekodS9AAAAAElFTkSuQmCC"
  },
  "description": "This is a template by Tagglo. Use this to monitor any tag in Google Tag Manager.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "endPoint",
    "displayName": "GET request endpoint",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Require the necessary APIs
const addEventCallback = require("addEventCallback");
const copyFromDataLayer = require("copyFromDataLayer");
const isConsentGranted = require("isConsentGranted");
const sendPixel = require("sendPixel");
const getTimestamp = require("getTimestamp");
const log = require("logToConsole");
const getContainerVersion = require("getContainerVersion");
const getUrl = require("getUrl");
const parseUrl = require("parseUrl");
const encodeUriComponent = require("encodeUriComponent");
const JSON = require("JSON");
const toBase64 = require("toBase64");
const injectScript = require("injectScript");
const templateStorage = require('templateStorage');

// Get the dataLayer event that triggered the tag
const event = copyFromDataLayer("event");
const copyFromWindow = require("copyFromWindow");
const dataLayer = copyFromWindow("dataLayer");
const getCookieValues = require("getCookieValues");
const getQueryParameters = require("getQueryParameters");
const gtmEventUniqueId = copyFromDataLayer("gtm.uniqueEventId");

// To keep request URL length under 2000 characters, we need to split the tags array into chunks
const maxTagsPerRequest = 8;

const ADBLOCK_NOT_CHECKED = 1;
const ADBLOCK_DETECTED = 2;
const ADBLOCK_NOT_DETECTED= 3;

let adBlockStatus = templateStorage.getItem('adBlockStatus') || ADBLOCK_NOT_CHECKED;


if(adBlockStatus == ADBLOCK_NOT_CHECKED){
   templateStorage.setItem('adBlockStatus', ADBLOCK_NOT_DETECTED);
   log('Checking for Adblock');
injectScript('https://storage.googleapis.com/tagglo-cdn/adservice.js', onSuccessAdBlock, onFailureAdBlock);
}

function onSuccessAdBlock(){
  adBlockStatus = ADBLOCK_NOT_DETECTED;
  templateStorage.setItem('adBlockStatus', ADBLOCK_NOT_DETECTED);
  log('No Adblock Detected');
}

function onFailureAdBlock(){
  adBlockStatus = ADBLOCK_DETECTED;
  templateStorage.setItem('adBlockStatus', ADBLOCK_DETECTED);
  log('Adblock Detected');
}

// Add a timestamp to separate events named the same way from each other
const eventTimestamp = getTimestamp();
const cv = getContainerVersion();
const endPoint = data.endPoint;
const url = getUrl();

function getEventDataFromDataLayer() {
  if (!dataLayer) {
    log("Failed to get datalayer data: no dataLayer object");
    return null;
  }

  if (!gtmEventUniqueId) {
    log("Failed to get datalayer data: no gtm.uniqueEventId");
    return null;
  }

  // Get object from dataLayer that matches the gtm.uniqueEventId
  let dataLayerRawData = dataLayer.map((o) => {
    // If falsy (due to e.g. sandbox API suppressing the object), return empty object
    if (!o) return {};

    // If a regular dataLayer object, return it
    if (o["gtm.uniqueEventId"]) return o;

    // Otherwise assume it's a template constructor-based object
    // Clone the object to remove constructor, then return first
    // property in the object (the wrapper)
    o = JSON.parse(JSON.stringify(o));
    for (let prop in o) {
      return o[prop];
    }
  });

  // Filter to only include the item(s) where the event ID matches
  const currentEventData = dataLayerRawData.filter(
    (o) => !!o && o["gtm.uniqueEventId"] === gtmEventUniqueId
  );

  log("event dataLayer data:", currentEventData);

  if (currentEventData.length === 0) {
    log(
      "Failed to get datalayer data: no dataLayer object with gtm.uniqueEventId " +
        gtmEventUniqueId
    );
    return null;
  }

  return currentEventData[0];
}

function extractHostname(url) {
  var hostname;

  if (url.indexOf("//") > -1) {
    hostname = url.split("/")[2];
  } else {
    hostname = url.split("/")[0];
  }

  //find & remove port number
  hostname = hostname.split(":")[0];
  //find & remove "?"
  hostname = hostname.split("?")[0];

  return hostname;
}

const isDebugMode = cv.debugMode || cv.previewMode;

function onSuccess(success) {
  log("success");
  log(success);
}
function onError(err) {
  log("error");
  log(err);
}

function getEventType(event) {
  switch (event) {
    case "gtm.js":
      return "container_loaded";

    case "gtm.init":
      return "initialization";

    case "gtm.dom":
      return "dom_loaded";

    case "gtm.click":
      return "click";

    case "gtm.history_change":
      return "history_change";

    case "gtm.load":
      return "window_loaded";

    case "gtm.init_consent":
      return "consent_initialization";

    default:
      return "custom_event";
  }
}


function mergeObjects(obj1, obj2) {
  var newObj = {};
  for (let attr in obj1) {
    newObj[attr] = obj1[attr];
  }
  for (let attr in obj2) {
    newObj[attr] = obj2[attr];
  }
  return newObj;
}

function sendPixelRequest(eventPayload, tagsArray) {
  let hasTags = !!tagsArray;

  if (hasTags) {
    eventPayload = mergeObjects({}, eventPayload);
    eventPayload.tags = tagsArray;
  }

  const eventJsonString = JSON.stringify(eventPayload);
  const base64 = toBase64(eventJsonString);
  const pixelUrl = endPoint + "?ed=" + base64;

  log(eventPayload);
  log(pixelUrl + " -- length: " + pixelUrl.length);

  if (isDebugMode) {
    return;
  }
  sendPixel(pixelUrl, onSuccess, onError);
}

function splitArrayToChunks(array, chunkSize) {
  var results = [];

  while (array.length) {
    results.push(array.splice(0, chunkSize));
  }

  return results;
}

function sendPixelWithChunkedTags(eventPayload, tags) {
  const tagsPayload = [];
  for (const tag of tags) {
   log(tag);
    const tagType = tag.type ? tag.type : "undefined";
    const consent = tag.consentTypesRequired ? tag.consentTypesRequired
          .split(",")
          .map((consent) =>
            encodeUriComponent(consent + ":" + isConsentGranted(consent))
          )
      : [];

    tagsPayload.push({
      tagId: tag.id,
      tagName: tag.name,
      tagStatus: tag.status,
      tagExecutionTime: tag.executionTime,
      tagConsent: consent,
      tagType: tagType,
    });
  }
  sendPixelRequest(eventPayload, tagsPayload);
}

// The addEventCallback gets two arguments: container ID and a data object with an array of tags that fired
addEventCallback((ctid, eventData) => {
  // Filter out the monitoring tag itself
  const tags = eventData.tags.filter(
    (t) => !(t.hasOwnProperty("exclude") && t.exclude == "true")
  );
  log("Event tags fired:", tags);

  const urlComponents = parseUrl(url);
  const ga = getCookieValues('_ga');
  const fbc = getCookieValues('_fbc');
  const fbp = getCookieValues('_fbp');
  const gcl_aw = getCookieValues('_gcl_aw');
  const fpgclaw = getCookieValues('FPGCLAW');

  let eventPayload = {
    adblock: adBlockStatus === ADBLOCK_DETECTED,
    hostname: extractHostname(url),
    eventName: event,
    eventType: getEventType(event),
    eventTimestamp: eventTimestamp,
    eventData: getEventDataFromDataLayer(),
    containerId: cv.containerId,
    gtmVersionId: cv.version,
    gtmEnvironment: cv.environmentName,
    tags: [],
    pagePath: urlComponents.pathname || '',
    ga: ga ? ga[0] : '',
    gclid: getQueryParameters('gclid') || '',
    gcl_aw: gcl_aw ? gcl_aw[0] : '',
    fpgclaw: fpgclaw ? fpgclaw[0] : '',
    fbclid: getQueryParameters('fbclid') || '',
    fbp: fbp ? fbp[0] : '',
    fbc: fbc ? fbc[0] : '',
  };

  const sendOnlyEvent = tags.length === 0;

  if (sendOnlyEvent) {
    sendPixelRequest(eventPayload);
    return;
  }

  const chunks = splitArrayToChunks(tags, maxTagsPerRequest);

  for (let chunkOfTags of chunks) {
    sendPixelWithChunkedTags(eventPayload, chunkOfTags);
  }
});

// After adding the callback, signal tag completion
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_metadata",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event"
              },
              {
                "type": 1,
                "string": "gtm.uniqueEventId"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_pixel",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
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
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
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
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "_ga"
              },
              {
                "type": 1,
                "string": "_gcl_aw"
              },
              {
                "type": 1,
                "string": "_fbp"
              },
              {
                "type": 1,
                "string": "_fbc"
              },
              {
                "type": 1,
                "string": "FPGCLAW"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://storage.googleapis.com/tagglo-cdn/adservice.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2022-10-30 22:33:23


