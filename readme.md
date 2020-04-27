### Build Docker image

```
docker-compose build --no-cache ioquake3
```

### Tag and upload Docker image

```
docker tag ioquake3server_ioquake3 gcr.io/weissig-core/ioquake3-ded:1.0.0
docker push gcr.io/weissig-core/ioquake3-ded:1.0.0
```
(Note: Don't forget to update the tag if you're uploading a new version.)

### Reserve IP address

```
gcloud compute addresses create quake3-ip \
    --region us-east1 --project weissig-core
```

### Show IP address

```
gcloud compute addresses describe quake3-ip --project weissig-core --region us-east1
```

### Create VM

```
gcloud compute instances create-with-container quake3 \
    --container-image gcr.io/weissig-core/ioquake3-ded:1.0.0 \
    --machine-type f1-micro \
    --project weissig-core \
    --zone us-east1-b \
    --tags quake3-server \
    --address <ip address>
```
(Note: Replace IP address with actual reserved IP address.)

### Create Firewall rule

```
gcloud compute firewall-rules create allow-quake3 \
    --allow tcp:27950,tcp:27952,tcp:27960,tcp:27965,udp:27950,udp:27952,udp:27960,udp:27965 \
    --target-tags quake3-server --project weissig-core
```

### Delete VM

```
gcloud compute instances delete quake3 --project weissig-core --zone us-east1-b
```