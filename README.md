# Adswap Tag Monitor

This is a template for Adswap Tag Monitoring. Use this to monitor any tag in Google Tag Manager.


## How to use

1. Go to Templates in Google Tag Manager
2. Click on "Search Gellry" and select "Adswap Tag Monitor"
4. Click on "Use" to add the template to your workspace
5. save the template

## How to configure

1. Go to Tags in Google Tag Manager
2. Click on "New"
3. Select "Adswap Tag Monitor"
4. Configure the tag
5. Add entry point provided by Adswap to the "GET request endpoint" field
6. Click on Advanced Settings -> Addition Tag Metadata
7. CHeck "Inbclude tag name"
8. Set "key for tah name" to "name"
9. Add + Add metadata button and ad "key" and "value" as exlude and "true", this is to exlude the tag itself from the monitoring
10. Add "triggering" rule" to the tag
11. Choose Custom Event has tag type
12. Add .* as event name
13. Selcet "All custom events"
14. Referens to this Trigger should automaticly be added to the tag (Adswap Tag Monitor)
15. Save the tag