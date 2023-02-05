#!/bin/bash

set -e

cat <<EOF >policy.rego
package use_data
get := data.values[input.k]
sum := data.values[input.k] + data.values[input.u]
EOF

echo -n "Pushing the policy: "
curl -s -X PUT opa:8181/v1/policies/use_data --data-binary @policy.rego | jq .

echo -n "Creating an empty document: "
curl -s -X PUT opa:8181/v1/data/values --data-binary '{}' && echo "OK"

echo -n "Setting A=1, B=2, C=3: "
curl -s -X PATCH opa:8181/v1/data/values --data-binary '[{"op":"add","path":"/a","value":1},{"op":"add","path":"/b","value":2},{"op":"add","path":"/c","value":3}]' && echo "OK"

echo -n "A: "
curl -s opa:8181/v1/data/use_data/get --data-binary '{"input":{"k":"a"}}' | jq .result

echo -n "B: "
curl -s opa:8181/v1/data/use_data/get --data-binary '{"input":{"k":"b"}}' | jq .result

echo -n "C: "
curl -s opa:8181/v1/data/use_data/get --data-binary '{"input":{"k":"c"}}' | jq .result

echo -n "A+B: "
curl -s opa:8181/v1/data/use_data/sum --data-binary '{"input":{"k":"a","u":"b"}}' | jq .result

echo -n "A+C: "
curl -s opa:8181/v1/data/use_data/sum --data-binary '{"input":{"k":"a","u":"c"}}' | jq .result

echo -n "B+C: "
curl -s opa:8181/v1/data/use_data/sum --data-binary '{"input":{"k":"b","u":"c"}}' | jq .result

echo -n "Changing A=11: "
curl -s -X PATCH opa:8181/v1/data/values --data-binary '[{"op":"replace","path":"/a","value":11}]' && echo "OK"

echo -n "A: "
curl -s opa:8181/v1/data/use_data/get --data-binary '{"input":{"k":"a"}}' | jq .result

echo -n "B: "
curl -s opa:8181/v1/data/use_data/get --data-binary '{"input":{"k":"b"}}' | jq .result

echo -n "C: "
curl -s opa:8181/v1/data/use_data/get --data-binary '{"input":{"k":"c"}}' | jq .result

echo -n "A+B: "
curl -s opa:8181/v1/data/use_data/sum --data-binary '{"input":{"k":"a","u":"b"}}' | jq .result

echo -n "A+C: "
curl -s opa:8181/v1/data/use_data/sum --data-binary '{"input":{"k":"a","u":"c"}}' | jq .result

echo -n "B+C: "
curl -s opa:8181/v1/data/use_data/sum --data-binary '{"input":{"k":"b","u":"c"}}' | jq .result


echo "Done, terminating."
touch /shared/.stop
