# OCWA Validate API

Validates outputs based on policies


# Running

````
docker build --tag ocwa_validate_api .

--

docker run -e POLICY_URL=PolicyApiUrl -e STORAGE_HOST=MyS3StyleHost -e STORAGE_BUCKET=MyS3StyleBucket -e STORAGE_ACCESS_KEY=MyS3AccessKey -e STORAGE_ACCESS_SECRET=MyS3AccessSecret -e API_SECRET=MySecret -e LOG_LEVEL=info -e DB_USERNAME=mongoUser -e DB_PASSWORD=mongoPassword -e DB_NAME=mongoDbName -e DB_PORT=27017 -e USER_ID_FIELD=Email  -e DB_HOST=docker --add-host=docker:$hostip -p LOCALPORT:3003 ocwa_validate_api

````

http://localhost:3003/v1/api-docs

curl -v http://localhost:3003/v1/validate

## Helm
For both below helm commands make a copy of values.yaml within the helm/validate-api directory
and modify it to contain the values specific for your deployment.

### Helm install (Kubernetes)
helm install --name ocwa-validate-api --namespace ocwa ./helm/validate-api -f ./helm/validate-api/config.yaml

### Helm update (Kubernetes)
helm upgrade --name ocwa-validate-api ./helm/validate-api  -f ./helm/validate-api/config.yaml

# Test

```
$ pip install '.[test]'
$ pytest --verbose
```

Run with coverage support:

```
$ coverage run -m pytest
$ coverage report
$ coverage html  # open htmlcov/index.html in a browser
```
