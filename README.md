# Adswap Tag Monitor

This is a template for Adswap Tag Monitoring. Use this to monitor any tag in Google Tag Manager.


## How to add our tag to your workspace

1. Go to Community Template Gallery in Google Tag Manager
2. Search for "Adswap Tag Monitor"
3. Click on "Add to worspace"

## How to configure our tag

1. Go to Tags in Google Tag Manager
2. Click on "New"
3. Select "Adswap Tag Monitor"
4. Add entry point provided by Adswap to the "GET request endpoint" field
5. Click on Advanced Settings -> Addition Tag Metadata
6. Check "Include tag name"
7. Set "key for the name" to "name"
8. Click Additional Tag Metadata button and add "key value": exclude and "value": true (this will exlude the tag from the monitoring itself)
9. Add "triggering rule" to the tag
10. Choose "Custom Event" as triggering type
11. Add .* as event name
12. Selcet "All custom events"
13. Reference to this Trigger should automaticly be added to the tag (Adswap Tag Monitor)
14. Save the tag and deploy your container
