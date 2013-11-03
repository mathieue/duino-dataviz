# setup elasticsearch mapping

curl -XDELETE 'http://127.0.0.1:9200/duinodataviz'
curl -XPUT 'http://127.0.0.1:9200/duinodataviz/' -d '{
 "index.mapper.dynamic": false
}'

curl -XPUT 'http://127.0.0.1:9200/duinodataviz/record/_mapping' -d '
{
    "record" : {
        "properties" : {
            "datetime": {
                "type" : "date",
                "format" : "yyyy-MM-dd HH:mm:ss"
            },
            "type": {
                "type": "string"
            },
            "value": {
                "type": "float"
            }
 
        }
    }
}
'