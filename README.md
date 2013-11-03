duino-dataviz
=============

A data visualization based on arduino sensors.

Arduino poll sensor values each seconds:
 * luminosity
 * mean sonore level
 * temperature

Any other sensor could be added.

Data are written to a sd card (this avoid us having connectivity and a backend replying).
The format is a simple csv.

Then the csv is imported in google refine to be exported to a bulk elasticsearch format with the template template-google-refine

Make the es mapping with make-es-schema.sh

And then import the bluk data in es.

next step is visualizing, with a tool like kibana first and then an angular.js d3.js app.

Overview of elasticsearch bulk input
-------------

    { "index" : { "_index" : "duinodataviz", "_type" : "record" } }
    {"datetime" : {{jsonize(cells["datetime"].value)}}, "type": "lumiere", "value" : {{jsonize(cells["lumiere"].value)}} }
    { "index" : { "_index" : "duinodataviz", "_type" : "record" } }
    {"datetime" : {{jsonize(cells["datetime"].value)}}, "type": "temperature", "value" : {{jsonize(cells["temperature"].value)}} }
    { "index" : { "_index" : "duinodataviz", "_type" : "record" } }
    {"datetime" : {{jsonize(cells["datetime"].value)}}, "type": "son", "value" : {{jsonize(cells["son"].value)}} }